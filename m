Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E354F1F91
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiDDWye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233387AbiDDWxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:53:34 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985974BB98;
        Mon,  4 Apr 2022 15:12:09 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234KkA5Z005225;
        Mon, 4 Apr 2022 22:12:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ykZbWN9/VMBabT8v3N0syRSRIkVyCvxZxHtb0xD0vNA=;
 b=TQZ9QnWcRoiMkU5+5FHPS2U7h0WG8b+ziEKbwT/3x025c133lnJre6HBUw2gzsh2CrAt
 LG2zexKunJm+wEvO8jv8oTpxOvMkMhqlyAk+mZTnG2aR1z8yXJzCI758RpiV9VL9OXXC
 We73HHQIGQUzbWQbTtgNMLjA9yBRw7keKEkgO5L387Mw6WPBeD3K/nUQS1Z+og+YluIu
 0tJ/r2I/hiA5hIMDIRgdHje3N3Yo+5xp+1K6x6Xu8YIGxrLHaqCPC6FVbeRHvVz5QQPv
 K8OH/vTxJzlZfvioYAu7cYG8ePcdP6JMt38zwF+Ludl8SV/xNKRIQDdjb2ndUk6u4Mzq 2w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f880kj20s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:07 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234LxEwP031676;
        Mon, 4 Apr 2022 22:12:07 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f880kj20e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:07 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234Lr3M7014664;
        Mon, 4 Apr 2022 22:12:06 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 3f6e49q9dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 22:12:06 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234MC5D122937952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 22:12:05 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F35B78067;
        Mon,  4 Apr 2022 22:12:05 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E893A78069;
        Mon,  4 Apr 2022 22:12:03 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.65.234.56])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 22:12:03 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v19 17/20] s390/vfio-ap: handle config changed and scan complete notification
Date:   Mon,  4 Apr 2022 18:10:36 -0400
Message-Id: <20220404221039.1272245-18-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1sekongBDGbrQ1Tc7Rez96_2WhpLfjAM
X-Proofpoint-GUID: L0Sf1gSHSWG850t5cVARuc5jf8VxhRMA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 mlxscore=0
 clxscore=1015 mlxlogscore=999 bulkscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

This patch implements two new AP driver callbacks:

void (*on_config_changed)(struct ap_config_info *new_config_info,
                  struct ap_config_info *old_config_info);

void (*on_scan_complete)(struct ap_config_info *new_config_info,
                 struct ap_config_info *old_config_info);

The on_config_changed callback is invoked at the start of the AP bus scan
function when it determines that the host AP configuration information
has changed since the previous scan.

The vfio_ap device driver registers a callback function for this callback
that performs the following operations:

1. Unplugs the adapters, domains and control domains removed from the
host's AP configuration from the guests to which they are
assigned in a single operation.

2. Stores bitmaps identifying the adapters, domains and control domains
added to the host's AP configuration with the structure representing
the mediated device. When the vfio_ap device driver's probe callback is
subsequently invoked, the probe function will recognize that the
queue is being probed due to a change in the host's AP configuration
and the plugging of the queue into the guest will be bypassed.

The on_scan_complete callback is invoked after the ap bus scan is
completed if the host AP configuration data has changed. The vfio_ap
device driver registers a callback function for this callback that hot
plugs each queue and control domain added to the AP configuration for each
guest using them in a single hot plug operation.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |   2 +
 drivers/s390/crypto/vfio_ap_ops.c     | 270 +++++++++++++++++++++++++-
 drivers/s390/crypto/vfio_ap_private.h |  12 ++
 3 files changed, 279 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 2c3084589347..4d5dda34082f 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -108,6 +108,8 @@ static struct ap_driver vfio_ap_drv = {
 	.probe = vfio_ap_mdev_probe_queue,
 	.remove = vfio_ap_mdev_remove_queue,
 	.in_use = vfio_ap_mdev_resource_in_use,
+	.on_config_changed = vfio_ap_on_cfg_changed,
+	.on_scan_complete = vfio_ap_on_scan_complete,
 	.ids = ap_queue_ids,
 };
 
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 3e1a7f191c43..083526bdef76 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -641,16 +641,11 @@ static bool vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
 static bool vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
 				       struct ap_matrix_mdev *matrix_mdev)
 {
-	int ret;
 	unsigned long apid, apqi, apqn;
 	DECLARE_BITMAP(prev_shadow_apm, AP_DEVICES);
 	DECLARE_BITMAP(prev_shadow_aqm, AP_DOMAINS);
 	struct vfio_ap_queue *q;
 
-	ret = ap_qci(&matrix_dev->info);
-	if (ret)
-		return false;
-
 	bitmap_copy(prev_shadow_apm, matrix_mdev->shadow_apcb.apm, AP_DEVICES);
 	bitmap_copy(prev_shadow_aqm, matrix_mdev->shadow_apcb.aqm, AP_DOMAINS);
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
@@ -1960,3 +1955,268 @@ int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm)
 
 	return ret;
 }
+
+/**
+ * vfio_ap_mdev_hot_unplug_cfg - hot unplug the adapters, domains and control
+ *				 domains that have been removed from the host's
+ *				 AP configuration from a guest.
+ *
+ * @matrix_mdev: an ap_matrix_mdev object attached to a KVM guest.
+ * @aprem: the adapters that have been removed from the host's AP configuration
+ * @aqrem: the domains that have been removed from the host's AP configuration
+ * @cdrem: the control domains that have been removed from the host's AP
+ *	   configuration.
+ */
+static void vfio_ap_mdev_hot_unplug_cfg(struct ap_matrix_mdev *matrix_mdev,
+					unsigned long *aprem,
+					unsigned long *aqrem,
+					unsigned long *cdrem)
+{
+	int do_hotplug = 0;
+
+	if (!bitmap_empty(aprem, AP_DEVICES)) {
+		do_hotplug |= bitmap_andnot(matrix_mdev->shadow_apcb.apm,
+					    matrix_mdev->shadow_apcb.apm,
+					    aprem, AP_DEVICES);
+	}
+
+	if (!bitmap_empty(aqrem, AP_DOMAINS)) {
+		do_hotplug |= bitmap_andnot(matrix_mdev->shadow_apcb.aqm,
+					    matrix_mdev->shadow_apcb.aqm,
+					    aqrem, AP_DEVICES);
+	}
+
+	if (!bitmap_empty(cdrem, AP_DOMAINS))
+		do_hotplug |= bitmap_andnot(matrix_mdev->shadow_apcb.adm,
+					    matrix_mdev->shadow_apcb.adm,
+					    cdrem, AP_DOMAINS);
+
+	if (do_hotplug)
+		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+}
+
+/**
+ * vfio_ap_mdev_cfg_remove - determines which guests are using the adapters,
+ *			     domains and control domains that have been removed
+ *			     from the host AP configuration and unplugs them
+ *			     from those guests.
+ *
+ * @ap_remove:	bitmap specifying which adapters have been removed from the host
+ *		config.
+ * @aq_remove:	bitmap specifying which domains have been removed from the host
+ *		config.
+ * @cd_remove:	bitmap specifying which control domains have been removed from
+ *		the host config.
+ */
+static void vfio_ap_mdev_cfg_remove(unsigned long *ap_remove,
+				    unsigned long *aq_remove,
+				    unsigned long *cd_remove)
+{
+	struct ap_matrix_mdev *matrix_mdev;
+	DECLARE_BITMAP(aprem, AP_DEVICES);
+	DECLARE_BITMAP(aqrem, AP_DOMAINS);
+	DECLARE_BITMAP(cdrem, AP_DOMAINS);
+	int do_remove = 0;
+
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		if (!matrix_mdev->kvm)
+			continue;
+
+		mutex_lock(&matrix_mdev->kvm->lock);
+		mutex_lock(&matrix_dev->mdevs_lock);
+
+		do_remove |= bitmap_and(aprem, ap_remove,
+					  matrix_mdev->matrix.apm,
+					  AP_DEVICES);
+		do_remove |= bitmap_and(aqrem, aq_remove,
+					  matrix_mdev->matrix.aqm,
+					  AP_DOMAINS);
+		do_remove |= bitmap_andnot(cdrem, cd_remove,
+					     matrix_mdev->matrix.adm,
+					     AP_DOMAINS);
+
+		if (do_remove)
+			vfio_ap_mdev_hot_unplug_cfg(matrix_mdev, aprem, aqrem,
+						    cdrem);
+
+		mutex_unlock(&matrix_dev->mdevs_lock);
+		mutex_unlock(&matrix_mdev->kvm->lock);
+	}
+}
+
+/**
+ * vfio_ap_mdev_on_cfg_remove - responds to the removal of adapters, domains and
+ *				control domains from the host AP configuration
+ *				by unplugging them from the guests that are
+ *				using them.
+ * @cur_config_info: the current host AP configuration information
+ * @prev_config_info: the previous host AP configuration information
+ */
+static void vfio_ap_mdev_on_cfg_remove(struct ap_config_info *cur_config_info,
+				       struct ap_config_info *prev_config_info)
+{
+	int do_remove;
+	DECLARE_BITMAP(aprem, AP_DEVICES);
+	DECLARE_BITMAP(aqrem, AP_DOMAINS);
+	DECLARE_BITMAP(cdrem, AP_DOMAINS);
+
+	do_remove = bitmap_andnot(aprem,
+				  (unsigned long *)prev_config_info->apm,
+				  (unsigned long *)cur_config_info->apm,
+				  AP_DEVICES);
+	do_remove |= bitmap_andnot(aqrem,
+				   (unsigned long *)prev_config_info->aqm,
+				   (unsigned long *)cur_config_info->aqm,
+				   AP_DEVICES);
+	do_remove |= bitmap_andnot(cdrem,
+				   (unsigned long *)prev_config_info->adm,
+				   (unsigned long *)cur_config_info->adm,
+				   AP_DEVICES);
+
+	if (do_remove)
+		vfio_ap_mdev_cfg_remove(aprem, aqrem, cdrem);
+}
+
+/**
+ * vfio_ap_mdev_cfg_add - store bitmaps specifying the adapters, domains and
+ *			  control domains that have been added to the host's
+ *			  AP configuration for each matrix mdev to which they
+ *			  are assigned.
+ *
+ * @apm_add: a bitmap specifying the adapters that have been added to the AP
+ *	     configuration.
+ * @aqm_add: a bitmap specifying the domains that have been added to the AP
+ *	     configuration.
+ * @adm_add: a bitmap specifying the control domains that have been added to the
+ *	     AP configuration.
+ */
+static void vfio_ap_mdev_cfg_add(unsigned long *apm_add, unsigned long *aqm_add,
+				 unsigned long *adm_add)
+{
+	struct ap_matrix_mdev *matrix_mdev;
+
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		bitmap_and(matrix_mdev->apm_add,
+			   matrix_mdev->matrix.apm, apm_add, AP_DEVICES);
+		bitmap_and(matrix_mdev->aqm_add,
+			   matrix_mdev->matrix.aqm, aqm_add, AP_DOMAINS);
+		bitmap_and(matrix_mdev->adm_add,
+			   matrix_mdev->matrix.adm, adm_add, AP_DEVICES);
+	}
+}
+
+/**
+ * vfio_ap_mdev_on_cfg_add - responds to the addition of adapters, domains and
+ *			     control domains to the host AP configuration
+ *			     by updating the bitmaps that specify what adapters,
+ *			     domains and control domains have been added so they
+ *			     can be hot plugged into the guest when the AP bus
+ *			     scan completes (see vfio_ap_on_scan_complete
+ *			     function).
+ * @cur_config_info: the current AP configuration information
+ * @prev_config_info: the previous AP configuration information
+ */
+static void vfio_ap_mdev_on_cfg_add(struct ap_config_info *cur_config_info,
+				    struct ap_config_info *prev_config_info)
+{
+	bool do_add;
+	DECLARE_BITMAP(apm_add, AP_DEVICES);
+	DECLARE_BITMAP(aqm_add, AP_DOMAINS);
+	DECLARE_BITMAP(adm_add, AP_DOMAINS);
+
+	do_add = bitmap_andnot(apm_add,
+			       (unsigned long *)cur_config_info->apm,
+			       (unsigned long *)prev_config_info->apm,
+			       AP_DEVICES);
+	do_add |= bitmap_andnot(aqm_add,
+				(unsigned long *)cur_config_info->aqm,
+				(unsigned long *)prev_config_info->aqm,
+				AP_DOMAINS);
+	do_add |= bitmap_andnot(adm_add,
+				(unsigned long *)cur_config_info->adm,
+				(unsigned long *)prev_config_info->adm,
+				AP_DOMAINS);
+
+	if (do_add)
+		vfio_ap_mdev_cfg_add(apm_add, aqm_add, adm_add);
+}
+
+/**
+ * vfio_ap_on_cfg_changed - handles notification of changes to the host AP
+ *			    configuration.
+ *
+ * @cur_cfg_info: the current host AP configuration
+ * @prev_cfg_info: the previous host AP configuration
+ */
+void vfio_ap_on_cfg_changed(struct ap_config_info *cur_cfg_info,
+			    struct ap_config_info *prev_cfg_info)
+{
+	mutex_lock(&matrix_dev->guests_lock);
+
+	vfio_ap_mdev_on_cfg_remove(cur_cfg_info, prev_cfg_info);
+	vfio_ap_mdev_on_cfg_add(cur_cfg_info, prev_cfg_info);
+	memcpy(&matrix_dev->info, cur_cfg_info, sizeof(*cur_cfg_info));
+
+	mutex_unlock(&matrix_dev->guests_lock);
+}
+
+static void vfio_ap_mdev_hot_plug_cfg(struct ap_matrix_mdev *matrix_mdev)
+{
+	bool do_hotplug = false;
+	int filter_domains = 0;
+	int filter_adapters = 0;
+	DECLARE_BITMAP(apm, AP_DEVICES);
+	DECLARE_BITMAP(aqm, AP_DOMAINS);
+
+	mutex_lock(&matrix_mdev->kvm->lock);
+	mutex_lock(&matrix_dev->mdevs_lock);
+
+	filter_adapters = bitmap_and(apm, matrix_mdev->matrix.apm,
+				     matrix_mdev->apm_add, AP_DEVICES);
+	filter_domains = bitmap_and(aqm, matrix_mdev->matrix.aqm,
+				    matrix_mdev->aqm_add, AP_DOMAINS);
+
+	if (filter_adapters && filter_domains)
+		do_hotplug |= vfio_ap_mdev_filter_matrix(apm, aqm, matrix_mdev);
+	else if (filter_adapters)
+		do_hotplug |=
+			vfio_ap_mdev_filter_matrix(apm,
+						   matrix_mdev->shadow_apcb.aqm,
+						   matrix_mdev);
+	else
+		do_hotplug |=
+			vfio_ap_mdev_filter_matrix(matrix_mdev->shadow_apcb.apm,
+						   aqm, matrix_mdev);
+
+	if (bitmap_intersects(matrix_mdev->matrix.adm, matrix_mdev->adm_add,
+			      AP_DOMAINS))
+		do_hotplug |= vfio_ap_mdev_filter_cdoms(matrix_mdev);
+
+	if (do_hotplug)
+		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+
+	mutex_unlock(&matrix_dev->mdevs_lock);
+	mutex_unlock(&matrix_mdev->kvm->lock);
+}
+
+void vfio_ap_on_scan_complete(struct ap_config_info *new_config_info,
+			      struct ap_config_info *old_config_info)
+{
+	struct ap_matrix_mdev *matrix_mdev;
+
+	mutex_lock(&matrix_dev->guests_lock);
+
+	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		if (bitmap_empty(matrix_mdev->apm_add, AP_DEVICES) &&
+		    bitmap_empty(matrix_mdev->aqm_add, AP_DOMAINS) &&
+		    bitmap_empty(matrix_mdev->adm_add, AP_DOMAINS))
+			continue;
+
+		vfio_ap_mdev_hot_plug_cfg(matrix_mdev);
+		bitmap_clear(matrix_mdev->apm_add, 0, AP_DEVICES);
+		bitmap_clear(matrix_mdev->aqm_add, 0, AP_DOMAINS);
+		bitmap_clear(matrix_mdev->adm_add, 0, AP_DOMAINS);
+	}
+
+	mutex_unlock(&matrix_dev->guests_lock);
+}
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index cbffa0bd01da..5b72e642cd04 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -107,6 +107,10 @@ struct ap_queue_table {
  *		PQAP(AQIC) instruction.
  * @mdev:	the mediated device
  * @qtable:	table of queues (struct vfio_ap_queue) assigned to the mdev
+ * @apm_add:	bitmap of APIDs added to the host's AP configuration
+ * @aqm_add:	bitmap of APQIs added to the host's AP configuration
+ * @adm_add:	bitmap of control domain numbers added to the host's AP
+ *		configuration
  */
 struct ap_matrix_mdev {
 	struct vfio_device vdev;
@@ -119,6 +123,9 @@ struct ap_matrix_mdev {
 	crypto_hook pqap_hook;
 	struct mdev_device *mdev;
 	struct ap_queue_table qtable;
+	DECLARE_BITMAP(apm_add, AP_DEVICES);
+	DECLARE_BITMAP(aqm_add, AP_DOMAINS);
+	DECLARE_BITMAP(adm_add, AP_DOMAINS);
 };
 
 /**
@@ -149,4 +156,9 @@ void vfio_ap_mdev_remove_queue(struct ap_device *queue);
 
 int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
 
+void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
+			    struct ap_config_info *old_config_info);
+void vfio_ap_on_scan_complete(struct ap_config_info *new_config_info,
+			      struct ap_config_info *old_config_info);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.31.1

