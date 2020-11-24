Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593D72C333F
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 22:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387824AbgKXVk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 16:40:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10532 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729196AbgKXVky (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 16:40:54 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLWQiI092516;
        Tue, 24 Nov 2020 16:40:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=denOkxFRSEDMF/G2emdpNtE0upvOCAiqDWxoxE6njYo=;
 b=rZaaGOjqGypRZ0hHyITt0lckqHok8oO4v3aPZFoSHNV/GRC2nB0ZsBO42Qm/d2/wLv8c
 WbDO80otTsiE7tYS26FA5PEBZGMt9zktwCnm5ukJdJz2qZ+dPH/niIK24cZRwfZHfZwx
 BFz2wGONyb7NHgqVgwfLvfj/jVBfExn1APuXXKd/msAldM2QxkGgFNmaJRI03ZnOXbYl
 cMZNQKlaYWv+A7C5tcdR/e3PgPXkdMuZ70TYyIUn5OyYus0MODOIRDuSyNvWLgIrqL/J
 q7fNkSAHecvbqtKDk7V+WDvcNLWKKz4Osw0yGzU6l6rQCjZJFbQxfrD0qYzbvYxIeori hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34yghsjsfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:52 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AOLWkd6093436;
        Tue, 24 Nov 2020 16:40:50 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34yghsjsbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:49 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLbBKD029538;
        Tue, 24 Nov 2020 21:40:47 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03wdc.us.ibm.com with ESMTP id 35133nty60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 21:40:47 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOLek3r8717016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 21:40:46 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27B0EAE05F;
        Tue, 24 Nov 2020 21:40:46 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2C90AE067;
        Tue, 24 Nov 2020 21:40:44 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.195.249])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 21:40:44 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v12 16/17] s390/vfio-ap: handle AP bus scan completed notification
Date:   Tue, 24 Nov 2020 16:40:15 -0500
Message-Id: <20201124214016.3013-17-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201124214016.3013-1-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_08:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=3
 bulkscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 phishscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240125
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
 drivers/s390/crypto/vfio_ap_ops.c     | 54 +++++++++++++++++++++++++++
 drivers/s390/crypto/vfio_ap_private.h |  2 +
 3 files changed, 57 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index d7aa5543afef..357481e80b0a 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -152,6 +152,7 @@ static int __init vfio_ap_init(void)
 	vfio_ap_drv.in_use = vfio_ap_mdev_resource_in_use;
 	vfio_ap_drv.ids = ap_queue_ids;
 	vfio_ap_drv.on_config_changed = vfio_ap_on_cfg_changed;
+	vfio_ap_drv.on_scan_complete = vfio_ap_on_scan_complete;
 
 	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
 	if (ret) {
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 074147fae339..7bfad92dd5e7 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1805,3 +1805,57 @@ void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
 	vfio_ap_mdev_on_cfg_add();
 	mutex_unlock(&matrix_dev->lock);
 }
+
+static bool vfio_ap_assign_new_adapters(struct ap_matrix_mdev *matrix_mdev)
+{
+	unsigned long apid;
+	bool assigned = false;
+	DECLARE_BITMAP(ap_add, AP_DEVICES);
+
+	if (bitmap_empty(matrix_dev->ap_add, AP_DEVICES) ||
+	    !bitmap_and(ap_add, matrix_dev->ap_add, matrix_mdev->matrix.apm,
+			AP_DEVICES))
+		return false;
+
+	for_each_set_bit_inv(apid, ap_add, AP_DEVICES)
+		assigned |= vfio_ap_assign_apid_to_apcb(matrix_mdev, apid);
+
+	return assigned;
+}
+
+static bool vfio_ap_assign_new_domains(struct ap_matrix_mdev *matrix_mdev)
+{
+	unsigned long apqi;
+	bool assigned = false;
+	DECLARE_BITMAP(aq_add, AP_DOMAINS);
+
+	if (bitmap_empty(matrix_dev->aq_add, AP_DOMAINS) ||
+	    !bitmap_and(aq_add, matrix_dev->aq_add, matrix_mdev->matrix.aqm,
+			AP_DOMAINS))
+		return false;
+
+	for_each_set_bit_inv(apqi, aq_add, AP_DOMAINS)
+		assigned |= vfio_ap_assign_apqi_to_apcb(matrix_mdev, apqi);
+
+	return assigned;
+}
+
+void vfio_ap_on_scan_complete(struct ap_config_info *new_config_info,
+			      struct ap_config_info *old_config_info)
+{
+	bool do_hotplug;
+	struct ap_matrix_mdev *matrix_mdev;
+
+	mutex_lock(&matrix_dev->lock);
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		do_hotplug = vfio_ap_assign_new_adapters(matrix_mdev);
+		do_hotplug |= vfio_ap_assign_new_domains(matrix_mdev);
+
+		if (do_hotplug)
+			vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
+	}
+
+	bitmap_clear(matrix_dev->ap_add, 0, AP_DEVICES);
+	bitmap_clear(matrix_dev->aq_add, 0, AP_DOMAINS);
+	mutex_unlock(&matrix_dev->lock);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 7bd7e35eb2e0..807be361b95d 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -120,5 +120,7 @@ int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
 
 void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
 			    struct ap_config_info *old_config_info);
+void vfio_ap_on_scan_complete(struct ap_config_info *new_config_info,
+			      struct ap_config_info *old_config_info);
 
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.1

