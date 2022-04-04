Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44354F1F97
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242025AbiDDWy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237143AbiDDWxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:53:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CFE4BB8F;
        Mon,  4 Apr 2022 15:12:05 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234LuRbI006639;
        Mon, 4 Apr 2022 22:12:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=BVNvO04s9TMjtSrJGITA6Dx9+ZgzGe0lGQEgtgIK/0U=;
 b=SEm9G9Ns+OCIe1cHJMkCOkSKSn4hKABKGHrxWdULVIk8cVPM/pJqF8JekvpG2YeMDEn9
 YQA9o5WEZ0YH+0whIZ64iMOMaP5Ldvpc0sbyr1hxezQ/o8wM3HRuGPny9qYRsEb5xgqi
 JI8bD2WDbBuCk8E+nTStLddYHcl57w3oBShgOkW60KSd/pdha+d4F5neUVszdt/NPeqI
 MAd4oUqjncUkcHVi6jEdOrnRLlNaZEnedq1Jz0LURTXFh5IhpdcyiFuxi+Z9uHo8fyru
 KSb0yYXvksr0F57vKDQh93+wpiT02SNwPKMkLKR42xoyKIuAVuZPa+uqAcZZpZ4thZyT JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f85tc5366-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:02 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234MC2pi011333;
        Mon, 4 Apr 2022 22:12:02 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f85tc535w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:02 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234Lqx9s008511;
        Mon, 4 Apr 2022 22:12:01 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 3f6e4a79cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:01 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234MC0lV13107532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 22:12:00 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 414E278063;
        Mon,  4 Apr 2022 22:12:00 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 391657805C;
        Mon,  4 Apr 2022 22:11:59 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.65.234.56])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 22:11:59 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v19 13/20] s390/vfio-ap: hot plug/unplug of AP devices when probed/removed
Date:   Mon,  4 Apr 2022 18:10:32 -0400
Message-Id: <20220404221039.1272245-14-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gGC9U60z-iBRtQVGRm3mb25CXuab8GFd
X-Proofpoint-ORIG-GUID: Da8kq2HbpQO_lgwiO6o6S2gCTTWAv1BR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

When an AP queue device is probed or removed, if the mediated device is
attached to a KVM guest, the mediated device's adapter, domain and
control domain bitmaps must be filtered to update the guest's APCB and if
any changes are detected, the guest's APCB must then be hot plugged into
the guest to reflect those changes to the guest.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 47f808122ed2..ec5f37d726ec 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1752,9 +1752,11 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 		vfio_ap_mdev_link_queue(matrix_mdev, q);
 		memset(apm_delta, 0, sizeof(apm_delta));
 		set_bit_inv(AP_QID_CARD(q->apqn), apm_delta);
-		vfio_ap_mdev_filter_matrix(apm_delta,
-					   matrix_mdev->matrix.aqm,
-					   matrix_mdev);
+
+		if (vfio_ap_mdev_filter_matrix(apm_delta,
+					       matrix_mdev->matrix.aqm,
+					       matrix_mdev))
+			vfio_ap_mdev_update_guest_apcb(matrix_mdev);
 	}
 	dev_set_drvdata(&apdev->device, q);
 	release_update_locks_for_mdev(matrix_mdev);
@@ -1764,7 +1766,7 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 
 void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 {
-	unsigned long apid;
+	unsigned long apid, apqi;
 	struct vfio_ap_queue *q;
 	struct ap_matrix_mdev *matrix_mdev;
 
@@ -1776,8 +1778,17 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 		vfio_ap_unlink_queue_fr_mdev(q);
 
 		apid = AP_QID_CARD(q->apqn);
-		if (test_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm))
-			clear_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm);
+		apqi = AP_QID_QUEUE(q->apqn);
+
+		/*
+		 * If the queue is assigned to the guest's APCB, then remove
+		 * the adapter's APID from the APCB and hot it into the guest.
+		 */
+		if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
+		    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
+			clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+			vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+		}
 	}
 
 	vfio_ap_mdev_reset_queue(q, 1);
-- 
2.31.1

