Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1B42C3346
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 22:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387751AbgKXVkz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 16:40:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19476 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387478AbgKXVkq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 16:40:46 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLWKdD084501;
        Tue, 24 Nov 2020 16:40:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=y8aOQT5SmnoXRKImunB67aX0WnBX0uZusSHN7hejNPU=;
 b=g1gBBE1nSrplt+dcpBwtTrgXwc87w+VPh5QJlfQjJPWMGbXpMngeaduFVy5gNeBjZNTI
 yVNpsinmSMT3W03XQAlCYO1yflauEcSF4ln098SFtEAydC/DrFjqKuphVXoa3gH5lBo3
 +wm4v05FFiCJQvFkliGuTMhmICwBN9+c8gB1uMjW5VkZoK0u4pohkmkkBvaaGA2j1+59
 S9GUVlLNrJI9OMxxxVhLJBbf3ORVP9xUbpbI6K3W/DF8sCyKNR3UMaq7jtEO/fgw9to4
 LemLRt9qbQ0Z3YH0ks1tbft2XFWtdh/Cqx/R9lfKEacdcb/9aCNG2mX9JwLdOFvQfdQz fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350rb1kfv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:46 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AOLXIZc087361;
        Tue, 24 Nov 2020 16:40:46 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350rb1kfus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:46 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLbNAL009355;
        Tue, 24 Nov 2020 21:40:44 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02wdc.us.ibm.com with ESMTP id 34xth92kr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 21:40:44 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOLehrH1966756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 21:40:43 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CEBFAE060;
        Tue, 24 Nov 2020 21:40:43 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D5AFAE062;
        Tue, 24 Nov 2020 21:40:42 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.195.249])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 21:40:42 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v12 14/17] s390/zcrypt: Notify driver on config changed and scan complete callbacks
Date:   Tue, 24 Nov 2020 16:40:13 -0500
Message-Id: <20201124214016.3013-15-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201124214016.3013-1-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_08:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 suspectscore=3 bulkscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch intruduces an extension to the ap bus to notify device drivers
when the host AP configuration changes - i.e., adapters, domains or
control domains are added or removed. To that end, two new callbacks are
introduced for AP device drivers:

  void (*on_config_changed)(struct ap_config_info *new_config_info,
                            struct ap_config_info *old_config_info);

     This callback is invoked at the start of the AP bus scan
     function when it determines that the host AP configuration information
     has changed since the previous scan. This is done by storing
     an old and current QCI info struct and comparing them. If there is any
     difference, the callback is invoked.

     Note that when the AP bus scan detects that AP adapters, domains or
     control domains have been removed from the host's AP configuration, it
     will remove the associated devices from the AP bus subsystem's device
     model. This callback gives the device driver a chance to respond to
     the removal of the AP devices from the host configuration prior to
     calling the device driver's remove callback. The primary purpose of
     this callback is to allow the vfio_ap driver to do a bulk unplug of
     all affected adapters, domains and control domains from affected
     guests rather than unplugging them one at a time when the remove
     callback is invoked.

  void (*on_scan_complete)(struct ap_config_info *new_config_info,
                           struct ap_config_info *old_config_info);

     The on_scan_complete callback is invoked after the ap bus scan is
     complete if the host AP configuration data has changed.

     Note that when the AP bus scan detects that adapters, domains or
     control domains have been added to the host's configuration, it will
     create new devices in the AP bus subsystem's device model. The primary
     purpose of this callback is to allow the vfio_ap driver to do a bulk
     plug of all affected adapters, domains and control domains into
     affected guests rather than plugging them one at a time when the
     probe callback is invoked.

Please note that changes to the apmask and aqmask do not trigger
these two callbacks since the bus scan function is not invoked by changes
to those masks.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/ap_bus.c          | 83 ++++++++++++++++++++++++++-
 drivers/s390/crypto/ap_bus.h          | 12 ++++
 drivers/s390/crypto/vfio_ap_private.h | 14 ++++-
 3 files changed, 106 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 593573740981..3a63f6b33d8a 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -75,6 +75,7 @@ DEFINE_MUTEX(ap_perms_mutex);
 EXPORT_SYMBOL(ap_perms_mutex);
 
 static struct ap_config_info *ap_qci_info;
+static struct ap_config_info *ap_qci_info_old;
 
 /*
  * AP bus related debug feature things.
@@ -1440,6 +1441,52 @@ static int __match_queue_device_with_queue_id(struct device *dev, const void *da
 		&& AP_QID_QUEUE(to_ap_queue(dev)->qid) == (int)(long) data;
 }
 
+/* Helper function for notify_config_changed */
+static int __drv_notify_config_changed(struct device_driver *drv, void *data)
+{
+	struct ap_driver *ap_drv = to_ap_drv(drv);
+
+	if (try_module_get(drv->owner)) {
+		if (ap_drv->on_config_changed)
+			ap_drv->on_config_changed(ap_qci_info,
+						  ap_qci_info_old);
+		module_put(drv->owner);
+	}
+
+	return 0;
+}
+
+/* Notify all drivers about an qci config change */
+static inline void notify_config_changed(void)
+{
+	bus_for_each_drv(&ap_bus_type, NULL, NULL,
+			 __drv_notify_config_changed);
+}
+
+/* Helper function for notify_scan_complete */
+static int __drv_notify_scan_complete(struct device_driver *drv, void *data)
+{
+	struct ap_driver *ap_drv = to_ap_drv(drv);
+
+	if (try_module_get(drv->owner)) {
+		if (ap_drv->on_scan_complete)
+			ap_drv->on_scan_complete(ap_qci_info,
+						 ap_qci_info_old);
+		module_put(drv->owner);
+	}
+
+	return 0;
+}
+
+/* Notify all drivers about bus scan complete */
+static inline void notify_scan_complete(void)
+{
+	bus_for_each_drv(&ap_bus_type, NULL, NULL,
+			 __drv_notify_scan_complete);
+}
+
+
+
 /*
  * Helper function for ap_scan_bus().
  * Remove card device and associated queue devices.
@@ -1718,15 +1765,43 @@ static inline void ap_scan_adapter(int ap)
 	put_device(&ac->ap_dev.device);
 }
 
+static int ap_get_configuration(void)
+{
+	int cfg_chg = 0;
+
+	if (ap_qci_info) {
+		if (!ap_qci_info_old) {
+			ap_qci_info_old = kzalloc(sizeof(*ap_qci_info_old),
+						  GFP_KERNEL);
+			if (!ap_qci_info_old)
+				return 0;
+		} else {
+			memcpy(ap_qci_info_old, ap_qci_info,
+			       sizeof(struct ap_config_info));
+		}
+		ap_fetch_qci_info(ap_qci_info);
+		cfg_chg = memcmp(ap_qci_info,
+				 ap_qci_info_old,
+				 sizeof(struct ap_config_info)) != 0;
+	}
+
+	return cfg_chg;
+}
+
 /**
  * ap_scan_bus(): Scan the AP bus for new devices
  * Runs periodically, workqueue timer (ap_config_time)
  */
 static void ap_scan_bus(struct work_struct *unused)
 {
-	int ap;
+	int ap, config_changed = 0;
 
-	ap_fetch_qci_info(ap_qci_info);
+	/* config change notify */
+	config_changed = ap_get_configuration();
+	if (config_changed)
+		notify_config_changed();
+	memcpy(ap_qci_info_old, ap_qci_info,
+	       sizeof(struct ap_config_info));
 	ap_select_domain();
 
 	AP_DBF_DBG("%s running\n", __func__);
@@ -1735,6 +1810,10 @@ static void ap_scan_bus(struct work_struct *unused)
 	for (ap = 0; ap <= ap_max_adapter_id; ap++)
 		ap_scan_adapter(ap);
 
+	/* scan complete notify */
+	if (config_changed)
+		notify_scan_complete();
+
 	/* check if there is at least one queue available with default domain */
 	if (ap_domain_index >= 0) {
 		struct device *dev =
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 65edd847c65a..fbfbf6991718 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -146,6 +146,18 @@ struct ap_driver {
 	int (*probe)(struct ap_device *);
 	void (*remove)(struct ap_device *);
 	int (*in_use)(unsigned long *apm, unsigned long *aqm);
+	/*
+	 * Called at the start of the ap bus scan function when
+	 * the crypto config information (qci) has changed.
+	 */
+	void (*on_config_changed)(struct ap_config_info *new_config_info,
+				  struct ap_config_info *old_config_info);
+	/*
+	 * Called at the end of the ap bus scan function when
+	 * the crypto config information (qci) has changed.
+	 */
+	void (*on_scan_complete)(struct ap_config_info *new_config_info,
+				 struct ap_config_info *old_config_info);
 };
 
 #define to_ap_drv(x) container_of((x), struct ap_driver, driver)
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 15b7cd74843b..7bd7e35eb2e0 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -36,14 +36,21 @@
  *		driver, be it using @mdev_list or writing the state of a
  *		single ap_matrix_mdev device. It's quite coarse but we don't
  *		expect much contention.
+ ** @ap_add:	a bitmap specifying the APIDs added to the host AP configuration
+ *		as notified by the AP bus via the on_cfg_chg callback.
+ * @aq_add:	a bitmap specifying the APQIs added to the host AP configuration
+ *		as notified by the AP bus via the on_cfg_chg callback.
  */
 struct ap_matrix_dev {
 	struct device device;
 	atomic_t available_instances;
-	struct ap_config_info info;
+	struct ap_config_info config_info;
+	struct ap_config_info config_info_prev;
 	struct list_head mdev_list;
 	struct mutex lock;
 	struct ap_driver  *vfio_ap_drv;
+	DECLARE_BITMAP(ap_add, AP_DEVICES);
+	DECLARE_BITMAP(aq_add, AP_DEVICES);
 };
 
 extern struct ap_matrix_dev *matrix_dev;
@@ -90,6 +97,8 @@ struct ap_matrix_mdev {
 	struct kvm_s390_module_hook pqap_hook;
 	struct mdev_device *mdev;
 	DECLARE_HASHTABLE(qtable, 8);
+	DECLARE_BITMAP(ap_add, AP_DEVICES);
+	DECLARE_BITMAP(aq_add, AP_DEVICES);
 };
 
 extern int vfio_ap_mdev_register(void);
@@ -109,4 +118,7 @@ void vfio_ap_mdev_remove_queue(struct ap_device *queue);
 
 int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
 
+void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
+			    struct ap_config_info *old_config_info);
+
 #endif /* _VFIO_AP_PRIVATE_H_ */
-- 
2.21.1

