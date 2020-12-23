Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2798E2E112F
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 02:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgLWBRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 20:17:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22376 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727140AbgLWBRL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Dec 2020 20:17:11 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BN1D6jV042020;
        Tue, 22 Dec 2020 20:16:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=BM0gsp9i5Z7VaydamiGjanfbVK2x+jcqdAJgY+gzcWk=;
 b=U41ya9kNnJK+9O8eLYnTdMN5QYkWcvO3US6wlGcnuQm0V1n+nbJUx+9ShN1cr7aON1p4
 n8vtfr5LDQhkvg7wmZpY9l33q50Cc4GiQKo6a8u6HB7C8Q6oi5NNjTWgLFHJgLrEc9WP
 20s+UVz6pJIIjqSliDwhBVfH1gcvqy32M5tvaTw9RsdOLz5YjzJVF8t7lXdP7ZWS8+20
 bj00vHN74GSx9Q4Ic1TD07UVHbfQH0T+PFTFXt8QhP+HPQu4BqKGXNnz94YPKlE9FN3T
 arRgG6yt3bq2yKnTpnUzDzNDkwoojCMaDgAdoeJCk7HLMlCdzgNKj0z3LgcDP7kjlRrc ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35kv1j01w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 20:16:28 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BN1DVLd043390;
        Tue, 22 Dec 2020 20:16:28 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35kv1j01w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Dec 2020 20:16:28 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BN1Cbge008142;
        Wed, 23 Dec 2020 01:16:27 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02wdc.us.ibm.com with ESMTP id 35km4gtqrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Dec 2020 01:16:27 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BN1GQ7U28967348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Dec 2020 01:16:26 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5747A112064;
        Wed, 23 Dec 2020 01:16:26 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B997112067;
        Wed, 23 Dec 2020 01:16:25 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.193.150])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 23 Dec 2020 01:16:25 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v13 12/15] s390/zcrypt: Notify driver on config changed and scan complete callbacks
Date:   Tue, 22 Dec 2020 20:16:03 -0500
Message-Id: <20201223011606.5265-13-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201223011606.5265-1-akrowiak@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-22_13:2020-12-21,2020-12-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012230003
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
 drivers/s390/crypto/ap_bus.c | 91 +++++++++++++++++++++++++++++++++++-
 drivers/s390/crypto/ap_bus.h | 12 +++++
 2 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 7d8add952dd6..788bfdaadafd 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -82,6 +82,7 @@ static atomic64_t ap_scan_bus_count;
 static DECLARE_COMPLETION(ap_init_apqn_bindings_complete);
 
 static struct ap_config_info *ap_qci_info;
+static struct ap_config_info *ap_qci_info_old;
 
 /*
  * AP bus related debug feature things.
@@ -1579,6 +1580,52 @@ static int __match_queue_device_with_queue_id(struct device *dev, const void *da
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
@@ -1857,15 +1904,51 @@ static inline void ap_scan_adapter(int ap)
 	put_device(&ac->ap_dev.device);
 }
 
+/*
+ * ap_get_configuration
+ *
+ * Stores the host AP configuration information returned from the previous call
+ * to Query Configuration Information (QCI), then retrieves and stores the
+ * current AP configuration returned from QCI.
+ *
+ * Returns true if the host AP configuration changed between calls to QCI;
+ * otherwise, returns false.
+ */
+static bool ap_get_configuration(void)
+{
+	bool cfg_chg = false;
+
+	if (ap_qci_info) {
+		if (!ap_qci_info_old) {
+			ap_qci_info_old = kzalloc(sizeof(*ap_qci_info_old),
+						  GFP_KERNEL);
+			if (!ap_qci_info_old)
+				return false;
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
 	ap_select_domain();
 
 	AP_DBF_DBG("%s running\n", __func__);
@@ -1874,6 +1957,10 @@ static void ap_scan_bus(struct work_struct *unused)
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
index 95c9da072f81..e91082bd159c 100644
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
-- 
2.21.1

