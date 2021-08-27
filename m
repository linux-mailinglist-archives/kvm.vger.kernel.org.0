Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D403F9805
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244720AbhH0KSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:18:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22776 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244926AbhH0KSS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 06:18:18 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17RA4Rwo027298
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=3T4FgP9AeH0NQHrp/R4MzARHy3e44BZguJfCVFUbHDc=;
 b=fEyO6biDk0JcW/uLT8C84ik8iiey5KJwFnACNYtGT/p0uI86oLr7d4MQTB1SAsiM7IiJ
 muohd5mm+Cze3+6UPOxEC8VD84aZ1cT1V0huIvC0mU6ezv8joN9Fci45vA/r+3LnMhvV
 uxh/ikW3r9r1UoUnmzeiYwAy+JSBm9arLS3j1LQHgVYzqj4zK3N6Godk9E0FF9PTyN1V
 eY+tI2NAO1cv4ZOHK8nnmzisiIXKyk4pBSHx0f7u/WS+p7bOjF8Vxgb4aVdk77T6xIPH
 K+ht78Eslkp2uvPb7xDF27a6Esx9o+Kqh2TJnUUqUd3MrDid4/l9BZeaW0BkQQgVwYQY /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apwpm8st9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:29 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17RA4TWC027496
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:29 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apwpm8ssg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 06:17:29 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17RADEu3004885;
        Fri, 27 Aug 2021 10:17:27 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3ajs48ka8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 10:17:27 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17RAHNuc29688150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 10:17:23 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BB424C050;
        Fri, 27 Aug 2021 10:17:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F44B4C040;
        Fri, 27 Aug 2021 10:17:23 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.164.230])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Aug 2021 10:17:23 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com
Subject: [kvm-unit-tests PATCH 6/7] s390x: virtio tests setup
Date:   Fri, 27 Aug 2021 12:17:19 +0200
Message-Id: <1630059440-15586-7-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6V5-QHZ4e41dhmnMsx8osjtDgu8N6V-K
X-Proofpoint-GUID: WiheB8Un6wcMbQqt1F6xYeZTCzSNqWgX
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_03:2021-08-26,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch can be squatch with the next one, "s390x: virtio data
transfer" and is separated to ease review.

In this patch we initialize the VIRTIO device.
There are currently no error insertion, the goal is to get an
initialized device to check data transfer within the next patch.

Future development will include error response checks.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/unittests.cfg |   4 +
 s390x/virtio_pong.c | 208 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 213 insertions(+)
 create mode 100644 s390x/virtio_pong.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 3f4acc3e..633e1af1 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
 tests += $(TEST_DIR)/uv-host.elf
 tests += $(TEST_DIR)/edat.elf
 tests += $(TEST_DIR)/mvpg-sie.elf
+tests += $(TEST_DIR)/virtio_pong.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 9e1802fd..dd84ed28 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -109,3 +109,7 @@ file = edat.elf
 
 [mvpg-sie]
 file = mvpg-sie.elf
+
+[virtio-pong]
+file = uv-virtio.elf
+extra_params = -device virtio-pong-cww
diff --git a/s390x/virtio_pong.c b/s390x/virtio_pong.c
new file mode 100644
index 00000000..1e050a4d
--- /dev/null
+++ b/s390x/virtio_pong.c
@@ -0,0 +1,208 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Channel Subsystem tests
+ *
+ * Copyright (c) 2021 IBM Corp
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ */
+#include <libcflat.h>
+#include <alloc_page.h>
+#include <asm/page.h>
+#include <string.h>
+#include <interrupt.h>
+#include <asm/arch_def.h>
+#include <asm/facility.h>
+#include <asm/uv.h>
+
+#include <css.h>
+#include <virtio.h>
+#include <virtio-config.h>
+#include <virtio-ccw.h>
+
+#include <malloc_io.h>
+#include <asm/time.h>
+
+#define VIRTIO_ID_PONG         30 /* virtio pong */
+
+#define VIRTIO_F_PONG_CKSUM	1
+
+#define SUPPORTED_FEATURES (1UL << VIRTIO_F_RING_INDIRECT_DESC	| \
+			    1UL << VIRTIO_F_RING_EVENT_IDX	| \
+			    1UL << VIRTIO_F_NOTIFY_ON_EMPTY	| \
+			    1UL << VIRTIO_F_ANY_LAYOUT	| \
+			    1UL << VIRTIO_F_PONG_CKSUM)
+
+static struct virtio_ccw_device *vcdev;
+static struct virtqueue *out_vq;
+static struct virtqueue *in_vq;
+
+static void test_find_vqs(void)
+{
+	struct virtio_device *vdev = &vcdev->vdev;
+	static const char *io_names[] = {"pong_input", "pong_output"};
+	struct virtqueue *vqs[2];
+	int ret;
+
+	if (vcdev->state != VCDEV_INIT) {
+		report_skip("Device non initialized");
+		vcdev->state = VCDEV_ERROR;
+		return;
+	}
+
+	ret = vdev->config->find_vqs(vdev, 2, vqs, NULL, io_names);
+	if (!ret) {
+		in_vq = vqs[0];
+		out_vq = vqs[1];
+	}
+	report(!ret, "Find virtqueues");
+}
+
+static int virtio_ccw_init_dev(struct virtio_ccw_device *vcdev)
+{
+	uint64_t features;
+	uint64_t unsupported_feat;
+	int ret;
+
+	ret = virtio_ccw_set_revision(vcdev);
+	report(!ret, "Revision 0");
+	if (ret)
+		return VCDEV_ERROR;
+
+	ret = virtio_ccw_reset(vcdev);
+	report(!ret, "RESET");
+	if (ret)
+		return VCDEV_ERROR;
+
+	ret = virtio_ccw_read_status(vcdev);
+	report(!ret && vcdev->status == 0, "Read Status : 0x%08x", vcdev->status);
+	if (ret)
+		return VCDEV_ERROR;
+
+	vcdev->status = VIRTIO_CONFIG_S_ACKNOWLEDGE | VIRTIO_CONFIG_S_DRIVER;
+	ret = virtio_ccw_write_status(vcdev);
+	report(!ret, "Write ACKNOWLEDGE and DRIVER Status: 0x%08x", vcdev->status);
+	if (ret)
+		return VCDEV_ERROR;
+
+	/* Checking features */
+	ret = virtio_ccw_read_features(vcdev, &features);
+	report(!ret, "Read features : 0x%016lx", features);
+	if (ret)
+		return VCDEV_ERROR;
+
+	report(features & 1UL << VIRTIO_F_RING_INDIRECT_DESC,
+	       "Feature: RING_INDIRECT_DESC");
+
+	report(features & 1UL << VIRTIO_F_RING_EVENT_IDX,
+	       "Feature: RING_EVENT_IDX");
+
+	unsupported_feat = features & ~SUPPORTED_FEATURES;
+	report(!unsupported_feat, "Features supported: 0x%016lx got 0x%016lx",
+	       SUPPORTED_FEATURES, features);
+	if (unsupported_feat)
+		return VCDEV_ERROR;
+
+	/* Accept supported features */
+	features &= SUPPORTED_FEATURES;
+	ret = virtio_ccw_write_features(vcdev, features);
+	report(!ret, "Write features: 0x%016lx", features);
+	if (ret)
+		return VCDEV_ERROR;
+
+	vcdev->status |= VIRTIO_CONFIG_S_FEATURES_OK;
+	ret = virtio_ccw_write_status(vcdev);
+	report(!ret, "Write FEATURES_OK Status: 0x%08x", vcdev->status);
+	if (ret)
+		return VCDEV_ERROR;
+
+	ret = virtio_ccw_read_status(vcdev);
+	report(!ret, "Read Status : 0x%08x", vcdev->status);
+	if (ret)
+		return VCDEV_ERROR;
+	report(vcdev->status & VIRTIO_CONFIG_S_FEATURES_OK, "Status: FEATURES_OK");
+	if (!(vcdev->status & VIRTIO_CONFIG_S_FEATURES_OK))
+		return VCDEV_ERROR;
+
+	ret = virtio_ccw_setup_indicators(vcdev);
+	report(!ret, "Setup indicators");
+	if (ret)
+		return VCDEV_ERROR;
+
+	vcdev->vdev.config = virtio_ccw_register();
+	if (!vcdev->vdev.config)
+		return VCDEV_ERROR;
+
+	vcdev->status |= VIRTIO_CONFIG_S_DRIVER_OK;
+	ret = virtio_ccw_write_status(vcdev);
+	report(!ret, "Write DRIVER_OK Status: 0x%08x", vcdev->status);
+	if (ret)
+		return VCDEV_ERROR;
+
+	return VCDEV_INIT;
+}
+
+static void test_virtio_device_init(void)
+{
+	struct virtio_device *vdev;
+
+	vdev = virtio_bind(VIRTIO_ID_PONG);
+	if (!vdev) {
+		report_abort("virtio_bind failed");
+		return;
+	}
+
+	vcdev = to_vc_device(vdev);
+	vcdev->state = virtio_ccw_init_dev(vcdev);
+	report(vcdev->state == VCDEV_INIT, "Initialization");
+}
+
+static void test_virtio_ccw_bus(void)
+{
+	report(virtio_ccw_init(), "Initialisation");
+}
+
+static void virtio_irq(void)
+{
+	/*
+	 * Empty function currently needed to setup IRQ by providing
+	 * an address to register_css_irq_func().
+	 * Will be use in the future to check parallel I/O.
+	 */
+}
+
+static int css_init(void)
+{
+	assert(register_css_irq_func(virtio_irq) == 0);
+	return 0;
+}
+
+static struct {
+	const char *name;
+	void (*func)(void);
+} tests[] = {
+	{ "CCW Bus", test_virtio_ccw_bus },
+	{ "CCW Device", test_virtio_device_init },
+	{ "Queues setup", test_find_vqs },
+	{ NULL, NULL }
+};
+
+int main(int argc, char *argv[])
+{
+	int i;
+
+	report_prefix_push("Virtio");
+
+	css_init();
+
+	for (i = 0; tests[i].name; i++) {
+		report_prefix_push(tests[i].name);
+		tests[i].func();
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	return report_summary();
+}
-- 
2.25.1

