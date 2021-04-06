Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA613557F5
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 17:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345832AbhDFPcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 11:32:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16944 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345749AbhDFPcD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 11:32:03 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 136F4iQM022628;
        Tue, 6 Apr 2021 11:31:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3V8PjsFC5usy3rYIcFerE07WaeGPF4lyCHnzt4Ch6XE=;
 b=WKBicUV7q8UN/jTTBNuHvcXqno5PdLPypUNM36Uvkcbh+Nxqkad5HpopnWUPtx3C1vh7
 nHBti2F+8U5084ClelhlJR9bAOYmlZOO0sT4IYMhkPLTBX2KdOwaouBBZpQEXbhkEEAm
 a/v372n1WPstOQoQQ8HCSi833+KjLIOsNFLdcyJ82tnAKe+RHAezxXvRvHmDkfPg9sOV
 dkIPobFn8sBZoSGYrHXdM6Q7V0b09kGX1jg0hgkX14x7QJ1wwnsAeMwsLfr09Z5fGKlQ
 SwAemFldgI2fks/G3Hqyuhspz2u4ezFLqs1Xu++s9EW6CLZV9AkqgzQOxD2JQOqKltUh XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rsxa9g5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 11:31:53 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 136F4kZW022954;
        Tue, 6 Apr 2021 11:31:52 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rsxa9g4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 11:31:52 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 136FMTm3012209;
        Tue, 6 Apr 2021 15:31:51 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 37q34d4qvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 15:31:51 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 136FVmdu28443074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 15:31:48 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79C42BE051;
        Tue,  6 Apr 2021 15:31:48 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D864ABE053;
        Tue,  6 Apr 2021 15:31:46 +0000 (GMT)
Received: from cpe-172-100-182-241.stny.res.rr.com.com (unknown [9.85.175.110])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 15:31:46 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v15 09/13] s390/zcrypt: driver callback to indicate resource in use
Date:   Tue,  6 Apr 2021 11:31:18 -0400
Message-Id: <20210406153122.22874-10-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20210406153122.22874-1-akrowiak@linux.ibm.com>
References: <20210406153122.22874-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TfFdZ8k_4DKEUt-xwv2ER84YZ03uLfjp
X-Proofpoint-GUID: itAPQvFCaPw3bUnbgDDmpGdlHMXFbw-S
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_04:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 bulkscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduces a new driver callback to prevent a root user from unbinding
an AP queue from its device driver if the queue is in use. The callback
will be invoked whenever a change to the AP bus's sysfs apmask or aqmask
attributes would result in one or more AP queues being removed from its
driver. If the callback responds in the affirmative for any driver
queried, the change to the apmask or aqmask will be rejected with a device
busy error.

For this patch, only non-default drivers will be queried. Currently,
there is only one non-default driver, the vfio_ap device driver. The
vfio_ap device driver facilitates pass-through of an AP queue to a
guest. The idea here is that a guest may be administered by a different
sysadmin than the host and we don't want AP resources to unexpectedly
disappear from a guest's AP configuration (i.e., adapters and domains
assigned to the matrix mdev). This will enforce the proper procedure for
removing AP resources intended for guest usage which is to
first unassign them from the matrix mdev, then unbind them from the
vfio_ap device driver.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
---
 drivers/s390/crypto/ap_bus.c | 160 ++++++++++++++++++++++++++++++++---
 drivers/s390/crypto/ap_bus.h |   4 +
 2 files changed, 154 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 2758d05a802d..b7653cec81ac 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -36,6 +36,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/debugfs.h>
 #include <linux/ctype.h>
+#include <linux/module.h>
 
 #include "ap_bus.h"
 #include "ap_debug.h"
@@ -1006,6 +1007,23 @@ static int modify_bitmap(const char *str, unsigned long *bitmap, int bits)
 	return 0;
 }
 
+static int ap_parse_bitmap_str(const char *str, unsigned long *bitmap, int bits,
+			       unsigned long *newmap)
+{
+	unsigned long size;
+	int rc;
+
+	size = BITS_TO_LONGS(bits) * sizeof(unsigned long);
+	if (*str == '+' || *str == '-') {
+		memcpy(newmap, bitmap, size);
+		rc = modify_bitmap(str, newmap, bits);
+	} else {
+		memset(newmap, 0, size);
+		rc = hex2bitmap(str, newmap, bits);
+	}
+	return rc;
+}
+
 int ap_parse_mask_str(const char *str,
 		      unsigned long *bitmap, int bits,
 		      struct mutex *lock)
@@ -1025,14 +1043,7 @@ int ap_parse_mask_str(const char *str,
 		kfree(newmap);
 		return -ERESTARTSYS;
 	}
-
-	if (*str == '+' || *str == '-') {
-		memcpy(newmap, bitmap, size);
-		rc = modify_bitmap(str, newmap, bits);
-	} else {
-		memset(newmap, 0, size);
-		rc = hex2bitmap(str, newmap, bits);
-	}
+	rc = ap_parse_bitmap_str(str, bitmap, bits, newmap);
 	if (rc == 0)
 		memcpy(bitmap, newmap, size);
 	mutex_unlock(lock);
@@ -1224,12 +1235,76 @@ static ssize_t apmask_show(struct bus_type *bus, char *buf)
 	return rc;
 }
 
+static int __verify_card_reservations(struct device_driver *drv, void *data)
+{
+	int rc = 0;
+	struct ap_driver *ap_drv = to_ap_drv(drv);
+	unsigned long *newapm = (unsigned long *)data;
+
+	/*
+	 * No need to verify whether the driver is using the queues if it is the
+	 * default driver.
+	 */
+	if (ap_drv->flags & AP_DRIVER_FLAG_DEFAULT)
+		return 0;
+
+	/*
+	 * increase the driver's module refcounter to be sure it is not
+	 * going away when we invoke the callback function.
+	 */
+	if (!try_module_get(drv->owner))
+		return 0;
+
+	if (ap_drv->in_use) {
+		rc = ap_drv->in_use(newapm, ap_perms.aqm);
+		if (rc)
+			rc = -EBUSY;
+	}
+
+	/* release the driver's module */
+	module_put(drv->owner);
+
+	return rc;
+}
+
+static int apmask_commit(unsigned long *newapm)
+{
+	int rc;
+	unsigned long reserved[BITS_TO_LONGS(AP_DEVICES)];
+
+	/*
+	 * Check if any bits in the apmask have been set which will
+	 * result in queues being removed from non-default drivers
+	 */
+	if (bitmap_andnot(reserved, newapm, ap_perms.apm, AP_DEVICES)) {
+		rc = bus_for_each_drv(&ap_bus_type, NULL, reserved,
+				      __verify_card_reservations);
+		if (rc)
+			return rc;
+	}
+
+	memcpy(ap_perms.apm, newapm, APMASKSIZE);
+
+	return 0;
+}
+
 static ssize_t apmask_store(struct bus_type *bus, const char *buf,
 			    size_t count)
 {
 	int rc;
+	DECLARE_BITMAP(newapm, AP_DEVICES);
+
+	if (mutex_lock_interruptible(&ap_perms_mutex))
+		return -ERESTARTSYS;
 
-	rc = ap_parse_mask_str(buf, ap_perms.apm, AP_DEVICES, &ap_perms_mutex);
+	rc = ap_parse_bitmap_str(buf, ap_perms.apm, AP_DEVICES, newapm);
+	if (rc)
+		goto done;
+
+	rc = apmask_commit(newapm);
+
+done:
+	mutex_unlock(&ap_perms_mutex);
 	if (rc)
 		return rc;
 
@@ -1255,12 +1330,77 @@ static ssize_t aqmask_show(struct bus_type *bus, char *buf)
 	return rc;
 }
 
+static int __verify_queue_reservations(struct device_driver *drv, void *data)
+{
+	int rc = 0;
+	struct ap_driver *ap_drv = to_ap_drv(drv);
+	unsigned long *newaqm = (unsigned long *)data;
+
+	/*
+	 * If the reserved bits do not identify queues reserved for use by the
+	 * non-default driver, there is no need to verify the driver is using
+	 * the queues.
+	 */
+	if (ap_drv->flags & AP_DRIVER_FLAG_DEFAULT)
+		return 0;
+
+	/*
+	 * increase the driver's module refcounter to be sure it is not
+	 * going away when we invoke the callback function.
+	 */
+	if (!try_module_get(drv->owner))
+		return 0;
+
+	if (ap_drv->in_use) {
+		rc = ap_drv->in_use(ap_perms.apm, newaqm);
+		if (rc)
+			return -EBUSY;
+	}
+
+	/* release the driver's module */
+	module_put(drv->owner);
+
+	return rc;
+}
+
+static int aqmask_commit(unsigned long *newaqm)
+{
+	int rc;
+	unsigned long reserved[BITS_TO_LONGS(AP_DOMAINS)];
+
+	/*
+	 * Check if any bits in the aqmask have been set which will
+	 * result in queues being removed from non-default drivers
+	 */
+	if (bitmap_andnot(reserved, newaqm, ap_perms.aqm, AP_DOMAINS)) {
+		rc = bus_for_each_drv(&ap_bus_type, NULL, reserved,
+				      __verify_queue_reservations);
+		if (rc)
+			return rc;
+	}
+
+	memcpy(ap_perms.aqm, newaqm, AQMASKSIZE);
+
+	return 0;
+}
+
 static ssize_t aqmask_store(struct bus_type *bus, const char *buf,
 			    size_t count)
 {
 	int rc;
+	DECLARE_BITMAP(newaqm, AP_DOMAINS);
+
+	if (mutex_lock_interruptible(&ap_perms_mutex))
+		return -ERESTARTSYS;
+
+	rc = ap_parse_bitmap_str(buf, ap_perms.aqm, AP_DOMAINS, newaqm);
+	if (rc)
+		goto done;
+
+	rc = aqmask_commit(newaqm);
 
-	rc = ap_parse_mask_str(buf, ap_perms.aqm, AP_DOMAINS, &ap_perms_mutex);
+done:
+	mutex_unlock(&ap_perms_mutex);
 	if (rc)
 		return rc;
 
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 472efd3a755c..95c9da072f81 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -145,6 +145,7 @@ struct ap_driver {
 
 	int (*probe)(struct ap_device *);
 	void (*remove)(struct ap_device *);
+	int (*in_use)(unsigned long *apm, unsigned long *aqm);
 };
 
 #define to_ap_drv(x) container_of((x), struct ap_driver, driver)
@@ -293,6 +294,9 @@ void ap_queue_init_state(struct ap_queue *aq);
 struct ap_card *ap_card_create(int id, int queue_depth, int raw_device_type,
 			       int comp_device_type, unsigned int functions);
 
+#define APMASKSIZE (BITS_TO_LONGS(AP_DEVICES) * sizeof(unsigned long))
+#define AQMASKSIZE (BITS_TO_LONGS(AP_DOMAINS) * sizeof(unsigned long))
+
 struct ap_perms {
 	unsigned long ioctlm[BITS_TO_LONGS(AP_IOCTLS)];
 	unsigned long apm[BITS_TO_LONGS(AP_DEVICES)];
-- 
2.21.3

