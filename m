Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50A1296392
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 19:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369106AbgJVRNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 13:13:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13448 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2898968AbgJVRNw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Oct 2020 13:13:52 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09MH3gvV030206;
        Thu, 22 Oct 2020 13:13:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IS0bnmL5yTCvtacFu3pktFy4Bzp3gilOC6zZ20NXIHM=;
 b=Id9vabknlzN2cLUgtqAeSIIjv1B1VWgfO8UHRyksTrAFgdgM6m+psJPtnEx/OnLXjqmz
 CbKR4RixcSJ0SNfvhJztoxx5GP7N871hO1cahlTyK8Ytz6DgSYi1/1Gxxje8QUYK7p2C
 BsuotjwtrpwrHoD7LFV7RYctNEtAsyaGRB610ffHg8GBxU6K+rKA3c/xDMdHn81LRaTJ
 zBGiN120rBHONySyNFxuVXrEocKckjdTvLKFcEcUVXJ0V4JEZysqXwWmd2G+DzCxIDqU
 XphQsq6vipZ0+AFEG61AY9D/YLnvhKUfcn01A9KkojfDJSK3i685Nob3EB6wguE2/Z/d jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34be27rjb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 13:13:49 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09MH3uls031796;
        Thu, 22 Oct 2020 13:13:49 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34be27rjax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 13:13:49 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09MHCxoL014939;
        Thu, 22 Oct 2020 17:13:48 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 347r89hypn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 17:13:48 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09MHCjAK49021358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 17:12:45 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78FFD7805F;
        Thu, 22 Oct 2020 17:12:45 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E04D778060;
        Thu, 22 Oct 2020 17:12:43 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.170.177])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 22 Oct 2020 17:12:43 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v11 13/14] s390/vfio-ap: handle AP bus scan completed notification
Date:   Thu, 22 Oct 2020 13:12:08 -0400
Message-Id: <20201022171209.19494-14-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201022171209.19494-1-akrowiak@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_12:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 mlxscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implements the driver callback invoked by the AP bus when the AP bus
scan has completed. Since this callback is invoked after binding the newly
added devices to their respective device drivers, the vfio_ap driver will
attempt to hot plug the adapters, domains and control domains into each
guest using the matrix mdev to which they are assigned. Keep in mind that
an adapter or domain can be plugged in only if each APQN with the APID of
the adapter or the APQI of the domain references a queue device bound
to the vfio_ap device driver. Consequently, not all newly added adapters
and domains will necessarily get hot plugged.

The same filtering operation used when the guest is started will again be
used to filter the APQNs assigned to the guest when the vfio_ap driver is
notified the AP bus scan has completed for those matrix mediated devices
to which the newly added APID(s) and/or APQI(s) are assigned.

To recap the filtering process employed:

For each APQN formulated from the Cartesian
product of the APIDs and APQIs assigned to the matrix mdev, if the APQN
does not reference a queue device bound to the vfio_ap device driver, the
APID will not be hot plugged into the guest. If any APIDs are left after
filtering, all of the queues referenced by the APQNs formulated by the
remaining APIDs and the APQIs assigned to the matrix mdev will be hot
plugged into the guest.

Control domains will not be filtered and will always be hot plugged.

Example:
    =======
    Queue devices bound to vfio_ap device driver:
       04.0004
       04.0047
       04.0054

       05.0005
       05.0047

    Adapters and domains assigned to matrix mdev:
       Adapters  Domains  -> Queues
       04        0004        04.0004
       05        0047        04.0047
                 0054        04.0054
                             05.0004
                             05.0047
                             05.0054

    KVM guest matrix after filtering:
       Adapters  Domains  -> Queues
       04        0004        04.0004
                 0047        04.0047
                 0054        04.0054

       Adapter 05 is filtered because queue 05.0054 is not bound.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |  1 +
 drivers/s390/crypto/vfio_ap_ops.c     | 26 ++++++++++++++++++++++++++
 drivers/s390/crypto/vfio_ap_private.h |  2 ++
 3 files changed, 29 insertions(+)

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
index 075096adbfd3..824f936364ba 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1837,3 +1837,29 @@ void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
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
+		if (!vfio_ap_mdev_has_crycb(matrix_mdev))
+			continue;
+
+		if (!bitmap_intersects(matrix_mdev->matrix.apm,
+				       matrix_dev->ap_add, AP_DEVICES) &&
+		    !bitmap_intersects(matrix_mdev->matrix.aqm,
+				       matrix_dev->aq_add, AP_DOMAINS))
+			continue;
+
+		if (vfio_ap_mdev_filter_guest_matrix(matrix_mdev,
+						     true))
+			vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
+	}
+
+	bitmap_clear(matrix_dev->ap_add, 0, AP_DEVICES);
+	bitmap_clear(matrix_dev->aq_add, 0, AP_DOMAINS);
+	mutex_unlock(&matrix_dev->lock);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 64f1f5b820f6..d82d1e62cb2f 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -119,5 +119,7 @@ void vfio_ap_mdev_remove_queue(struct ap_device *queue);
 bool vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
 void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
 			    struct ap_config_info *old_config_info);
+void vfio_ap_on_scan_complete(struct ap_config_info *new_config_info,
+			      struct ap_config_info *old_config_info);
 
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.1

