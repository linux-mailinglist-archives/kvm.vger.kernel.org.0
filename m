Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3B62E1138
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 02:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbgLWBRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 20:17:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16810 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727202AbgLWBRM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Dec 2020 20:17:12 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BN1CtlV051015;
        Tue, 22 Dec 2020 20:16:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EvLySD+SUP5+kSx3kDTrC6jDl4HnWa3DEwJQKk5IkG4=;
 b=fh7RucOPKAiU5GiRIe8AzqJ3Q9jkVAzNUJm7ghMxmbKWWD5NiFznrzScenMlo6uLqMhj
 9gPkIKqxgGxuMBtfTYDxpkUzMjcSliXhN7VZaAGhxTBc2iBCe345pECQYUhhQw+hdrBx
 kFTBnWASVJ9Id+frkcuEBIS7D/m2jmS6FH29QHEngqJXCZ6PMMrmN2SESW1xW8ncLrkr
 5rWx6tS4m53scVw2B4t2lJ78iyjnb1TdzTnvoxF9Ps3aWcspSez46i68Iit9HoD3kewj
 4aE5GfXjsm09i9YqEFTij14KqHS+XMJOg8hvNZ42L5NTKr4odrrZEIJgAYGJ6me7uXMe yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35kv1g0200-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 20:16:31 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BN1Dd7V055807;
        Tue, 22 Dec 2020 20:16:31 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35kv1g01yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 20:16:31 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BN1CKI3020500;
        Wed, 23 Dec 2020 01:16:30 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03wdc.us.ibm.com with ESMTP id 35kdqy56e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Dec 2020 01:16:30 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BN1GSiu30671282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Dec 2020 01:16:28 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CDD1112063;
        Wed, 23 Dec 2020 01:16:28 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 755FE112061;
        Wed, 23 Dec 2020 01:16:27 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.193.150])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 23 Dec 2020 01:16:27 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v13 14/15] s390/vfio-ap: handle AP bus scan completed notification
Date:   Tue, 22 Dec 2020 20:16:05 -0500
Message-Id: <20201223011606.5265-15-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201223011606.5265-1-akrowiak@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-22_13:2020-12-21,2020-12-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012230003
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implements the driver callback invoked by the AP bus when the AP bus
scan has completed. Since this callback is invoked after binding the newly
added devices to their respective device drivers, the vfio_ap driver will
attempt to hot plug the adapters, domains and control domains into each
guest using the matrix mdev to which they are assigned. Keep in mind that
an adapter or domain can be plugged in only if:
* Each APQN derived from the newly added APID of the adapter and the APQIs
  already assigned to the guest's APCB references an AP queue device bound
  to the vfio_ap driver
* Each APQN derived from the newly added APQI of the domain and the APIDs
  already assigned to the guest's APCB references an AP queue device bound
  to the vfio_ap driver

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |  1 +
 drivers/s390/crypto/vfio_ap_ops.c     | 21 +++++++++++++++++++++
 drivers/s390/crypto/vfio_ap_private.h |  2 ++
 3 files changed, 24 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 2029d8392416..075495fc44c0 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -149,6 +149,7 @@ static int __init vfio_ap_init(void)
 	vfio_ap_drv.remove = vfio_ap_mdev_remove_queue;
 	vfio_ap_drv.in_use = vfio_ap_mdev_resource_in_use;
 	vfio_ap_drv.on_config_changed = vfio_ap_on_cfg_changed;
+	vfio_ap_drv.on_scan_complete = vfio_ap_on_scan_complete;
 	vfio_ap_drv.ids = ap_queue_ids;
 
 	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 8bbbd1dc7546..b8ed01297812 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1592,3 +1592,24 @@ void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
 	vfio_ap_mdev_on_cfg_add();
 	mutex_unlock(&matrix_dev->lock);
 }
+
+void vfio_ap_on_scan_complete(struct ap_config_info *new_config_info,
+			      struct ap_config_info *old_config_info)
+{
+	struct ap_matrix_mdev *matrix_mdev;
+
+	mutex_lock(&matrix_dev->lock);
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		if (bitmap_intersects(matrix_mdev->matrix.apm,
+				      matrix_dev->ap_add, AP_DEVICES) ||
+		    bitmap_intersects(matrix_mdev->matrix.aqm,
+				      matrix_dev->aq_add, AP_DOMAINS) ||
+		    bitmap_intersects(matrix_mdev->matrix.adm,
+				      matrix_dev->ad_add, AP_DOMAINS))
+			vfio_ap_mdev_refresh_apcb(matrix_mdev);
+	}
+
+	bitmap_clear(matrix_dev->ap_add, 0, AP_DEVICES);
+	bitmap_clear(matrix_dev->aq_add, 0, AP_DOMAINS);
+	mutex_unlock(&matrix_dev->lock);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index b99b68968447..7f0f7c92e686 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -117,5 +117,7 @@ int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
 
 void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
 			    struct ap_config_info *old_config_info);
+void vfio_ap_on_scan_complete(struct ap_config_info *new_config_info,
+			      struct ap_config_info *old_config_info);
 
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.1

