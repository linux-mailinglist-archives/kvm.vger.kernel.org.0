Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4C74F1F82
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240384AbiDDWyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbiDDWxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:53:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B894BB83;
        Mon,  4 Apr 2022 15:12:00 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234IeCo5025559;
        Mon, 4 Apr 2022 22:11:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JSPOKpGkeZWBvNwUlZ4kItBcRs/kKrPYV4dGuKaJQBc=;
 b=QCPH+zog1VR2aoRN3FgVDp5zYJ4/DgLXHL/eBq67ozJsk58boAHthOTOEdFMoDgFOmLQ
 OngMzRuupYfdtfCsvQ9W5S5tG0q0QlpMp44SgZRuBZTySNcI9YRIxRrA1/kVvTOMMeca
 8vJH5s8b7nzTvsnn60UlcQ9StHc3wKkT7lzY+d3mi7Yzo3ORdxj4PwZR+Y8W9N0Ce2x4
 5DHK0/J6aD1m/pXcFJWrUVQ1W9kGN4IPXUPmp8wNPyDbNqxVwaVyJETCAv6OSxe7v2km
 ewMEzLI9LhBqQ6BKRDyLTxKcxsbPYWba3GjDII9s+X0dsBvv8/rVhyRvNcDBdjLLgEWt SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f84xcy1dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:57 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234LiYQ7011799;
        Mon, 4 Apr 2022 22:11:57 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f84xcy1d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:57 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234LqtXu027679;
        Mon, 4 Apr 2022 22:11:56 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02wdc.us.ibm.com with ESMTP id 3f6e49aq1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:11:56 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234MBtDa30867832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 22:11:55 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9214378064;
        Mon,  4 Apr 2022 22:11:55 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 871B37805C;
        Mon,  4 Apr 2022 22:11:54 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.65.234.56])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 22:11:54 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v19 09/20] s390/vfio-ap: use proper locking order when setting/clearing KVM pointer
Date:   Mon,  4 Apr 2022 18:10:28 -0400
Message-Id: <20220404221039.1272245-10-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: csn23umLau_rh7o0JNks6QRaRREpU0sX
X-Proofpoint-ORIG-GUID: QXTKuANjKfwzIbVogH7vr1lrLA8K-CPz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 impostorscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The group notifier that handles the VFIO_GROUP_NOTIFY_SET_KVM event must
use the required locks in proper locking order to dynamically update the
guest's APCB. The proper locking order is:

       1. matrix_dev->guests_lock: required to use the KVM pointer to
          update a KVM guest's APCB.

       2. matrix_mdev->kvm->lock: required to update a KVM guest's APCB.

       3. matrix_dev->mdevs_lock: required to store or access the data
          stored in a struct ap_matrix_mdev instance.

Two macros are introduced to acquire and release the locks in the proper
order. These macros are now used by the group notifier functions.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 56 +++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 077b8c9c831b..757bbf449b04 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -30,6 +30,47 @@ static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev);
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
 
+/**
+ * get_update_locks_for_kvm: Acquire the locks required to dynamically update a
+ *			     KVM guest's APCB in the proper order.
+ *
+ * @kvm: a pointer to a struct kvm object containing the KVM guest's APCB.
+ *
+ * The proper locking order is:
+ * 1. matrix_dev->guests_lock: required to use the KVM pointer to update a KVM
+ *			       guest's APCB.
+ * 2. kvm->lock:	       required to update a guest's APCB
+ * 3. matrix_dev->mdevs_lock:  required to access data stored in a matrix_mdev
+ *
+ * Note: If @kvm is NULL, the KVM lock will not be taken.
+ */
+#define get_update_locks_for_kvm(kvm) ({	\
+	mutex_lock(&matrix_dev->guests_lock);	\
+	if (kvm)				\
+		mutex_lock(&kvm->lock);		\
+	mutex_lock(&matrix_dev->mdevs_lock);	\
+})
+
+/**
+ * release_update_locks_for_kvm: Release the locks used to dynamically update a
+ *				 KVM guest's APCB in the proper order.
+ *
+ * @kvm: a pointer to a struct kvm object containing the KVM guest's APCB.
+ *
+ * The proper unlocking order is:
+ * 1. matrix_dev->mdevs_lock
+ * 2. kvm->lock
+ * 3. matrix_dev->guests_lock
+ *
+ * Note: If @kvm is NULL, the KVM lock will not be released.
+ */
+#define release_update_locks_for_kvm(kvm) ({	\
+	mutex_unlock(&matrix_dev->mdevs_lock);	\
+	if (kvm)				\
+		mutex_unlock(&kvm->lock);		\
+	mutex_unlock(&matrix_dev->guests_lock);	\
+})
+
 /**
  * vfio_ap_mdev_get_queue - retrieve a queue with a specific APQN from a
  *			    hash table of queues assigned to a matrix mdev
@@ -1263,13 +1304,11 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 		kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
 		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
 
-		mutex_lock(&kvm->lock);
-		mutex_lock(&matrix_dev->mdevs_lock);
+		get_update_locks_for_kvm(kvm);
 
 		list_for_each_entry(m, &matrix_dev->mdev_list, node) {
 			if (m != matrix_mdev && m->kvm == kvm) {
-				mutex_unlock(&kvm->lock);
-				mutex_unlock(&matrix_dev->mdevs_lock);
+				release_update_locks_for_kvm(kvm);
 				return -EPERM;
 			}
 		}
@@ -1280,8 +1319,7 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 					  matrix_mdev->shadow_apcb.aqm,
 					  matrix_mdev->shadow_apcb.adm);
 
-		mutex_unlock(&kvm->lock);
-		mutex_unlock(&matrix_dev->mdevs_lock);
+		release_update_locks_for_kvm(kvm);
 	}
 
 	return 0;
@@ -1332,16 +1370,14 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 		kvm->arch.crypto.pqap_hook = NULL;
 		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
 
-		mutex_lock(&kvm->lock);
-		mutex_lock(&matrix_dev->mdevs_lock);
+		get_update_locks_for_kvm(kvm);
 
 		kvm_arch_crypto_clear_masks(kvm);
 		vfio_ap_mdev_reset_queues(matrix_mdev);
 		kvm_put_kvm(kvm);
 		matrix_mdev->kvm = NULL;
 
-		mutex_unlock(&kvm->lock);
-		mutex_unlock(&matrix_dev->mdevs_lock);
+		release_update_locks_for_kvm(kvm);
 	}
 }
 
-- 
2.31.1

