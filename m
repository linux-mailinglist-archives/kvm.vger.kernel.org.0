Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F5A3F9841
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244898AbhH0Kvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:51:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47462 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244780AbhH0Kvy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 06:51:54 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17RAXlgd181479;
        Fri, 27 Aug 2021 06:51:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=sGO8g0KMsH6opJeOVtLKteOeyxh9rwi8TyZ1xjiJRLs=;
 b=NYGZtX/zgaZ7geFy/sNx31bMv4AZET7nsQqRVhh74+f0zf5OTfNhft0ccqoitaEq/Ie/
 AZzRd4HaL69vJc1FEYLwinOzYMyxQTSZryimNomjFmtWxmGfH/LXVIXWzH+CqismB40W
 tmfGIolJT9McGgrlP4Ev7B4AjoN4YG4+AKgRGesqcZdTS3Z7pbqd/VK25NmxxK30262r
 vbLQh7NE1A0pjrx/goemX4HnivTaqCiwcDeukpkZ413EK3GwHxEKMVJ3p4U1V20OcsB4
 WBFfcw8h9RIQ3nuGE6OD8GllcFB/ulSDi6v6OisO8iDkiyuEnSWML46m6BVkdYwBcbJX yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apwhkhv7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 06:51:00 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17RAXqFV182147;
        Fri, 27 Aug 2021 06:50:59 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apwhkhv6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 06:50:59 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17RAlmPe004909;
        Fri, 27 Aug 2021 10:50:57 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3ajs493bf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 10:50:57 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17RAor6q47251752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 10:50:53 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E08411C080;
        Fri, 27 Aug 2021 10:50:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D75A211C083;
        Fri, 27 Aug 2021 10:50:52 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.164.230])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Aug 2021 10:50:52 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com,
        qemu-s390x@nongnu.org, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        richard.henderson@linaro.org, mst@redhat.com, qemu-devel@nongnu.org
Subject: [PATCH 2/2] s390x: ccw: A simple test device for virtio CCW
Date:   Fri, 27 Aug 2021 12:50:50 +0200
Message-Id: <1630061450-18744-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630061450-18744-1-git-send-email-pmorel@linux.ibm.com>
References: <1630061450-18744-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1I3366asKwpTgqmLvGB7k3pTnXNdlUsY
X-Proofpoint-ORIG-GUID: XWlvv3Mh8leEylLEUqcjgXzmww1Boo97
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_03:2021-08-26,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 phishscore=0
 spamscore=0 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108270066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This VIRTIO device receives data on its input channel
and emit a simple checksum for these data on its
output channel.

This allows a simple VIRTIO device driver to check the
VIRTIO initialization and various data transfer.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 hw/s390x/meson.build            |   1 +
 hw/s390x/virtio-ccw-pong.c      |  66 +++++++++++++
 hw/s390x/virtio-ccw.h           |  13 +++
 hw/virtio/Kconfig               |   5 +
 hw/virtio/meson.build           |   1 +
 hw/virtio/virtio-pong.c         | 161 ++++++++++++++++++++++++++++++++
 include/hw/virtio/virtio-pong.h |  34 +++++++
 7 files changed, 281 insertions(+)
 create mode 100644 hw/s390x/virtio-ccw-pong.c
 create mode 100644 hw/virtio/virtio-pong.c
 create mode 100644 include/hw/virtio/virtio-pong.h

diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
index 74678861cf..e9edf1d196 100644
--- a/hw/s390x/meson.build
+++ b/hw/s390x/meson.build
@@ -18,6 +18,7 @@ s390x_ss.add(files(
   'sclpcpu.c',
   'sclpquiesce.c',
   'tod.c',
+  'virtio-ccw-pong.c',
 ))
 s390x_ss.add(when: 'CONFIG_KVM', if_true: files(
   'tod-kvm.c',
diff --git a/hw/s390x/virtio-ccw-pong.c b/hw/s390x/virtio-ccw-pong.c
new file mode 100644
index 0000000000..c4e343b776
--- /dev/null
+++ b/hw/s390x/virtio-ccw-pong.c
@@ -0,0 +1,66 @@
+/*
+ * virtio ccw PONG device
+ *
+ * Copyright 2020, IBM Corp.
+ * Author(s): Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+
+#include "qemu/osdep.h"
+#include "hw/qdev-properties.h"
+#include "hw/virtio/virtio.h"
+#include "qapi/error.h"
+#include "qemu/module.h"
+#include "virtio-ccw.h"
+
+static void virtio_ccw_pong_realize(VirtioCcwDevice *ccw_dev, Error **errp)
+{
+    VirtIOPONGCcw *dev = VIRTIO_PONG_CCW(ccw_dev);
+    DeviceState *vdev = DEVICE(&dev->vdev);
+
+    if (!qdev_realize(vdev, BUS(&ccw_dev->bus), errp)) {
+        return;
+    }
+}
+
+static void virtio_ccw_pong_instance_init(Object *obj)
+{
+    VirtIOPONGCcw *dev = VIRTIO_PONG_CCW(obj);
+
+    virtio_instance_init_common(obj, &dev->vdev, sizeof(dev->vdev),
+                                TYPE_VIRTIO_PONG);
+}
+
+static Property virtio_ccw_pong_properties[] = {
+    DEFINE_PROP_UINT32("max_revision", VirtioCcwDevice, max_rev,
+                       VIRTIO_CCW_MAX_REV),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static void virtio_ccw_pong_class_init(ObjectClass *klass, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(klass);
+    VirtIOCCWDeviceClass *k = VIRTIO_CCW_DEVICE_CLASS(klass);
+
+    k->realize = virtio_ccw_pong_realize;
+    device_class_set_props(dc, virtio_ccw_pong_properties);
+    set_bit(DEVICE_CATEGORY_MISC, dc->categories);
+}
+
+static const TypeInfo virtio_ccw_pong = {
+    .name          = TYPE_VIRTIO_PONG_CCW,
+    .parent        = TYPE_VIRTIO_CCW_DEVICE,
+    .instance_size = sizeof(VirtIOPONGCcw),
+    .instance_init = virtio_ccw_pong_instance_init,
+    .class_init    = virtio_ccw_pong_class_init,
+};
+
+static void virtio_ccw_pong_register(void)
+{
+    type_register_static(&virtio_ccw_pong);
+}
+
+type_init(virtio_ccw_pong_register)
diff --git a/hw/s390x/virtio-ccw.h b/hw/s390x/virtio-ccw.h
index 0168232e3b..f718ad32c2 100644
--- a/hw/s390x/virtio-ccw.h
+++ b/hw/s390x/virtio-ccw.h
@@ -31,6 +31,8 @@
 #include "hw/virtio/virtio-gpu.h"
 #include "hw/virtio/virtio-input.h"
 
+#include "hw/virtio/virtio-pong.h"
+
 #include "hw/s390x/s390_flic.h"
 #include "hw/s390x/css.h"
 #include "ccw-device.h"
@@ -176,6 +178,17 @@ struct VirtIORNGCcw {
     VirtIORNG vdev;
 };
 
+/* virtio-pong-ccw */
+
+#define TYPE_VIRTIO_PONG_CCW "virtio-pong-ccw"
+#define VIRTIO_PONG_CCW(obj) \
+        OBJECT_CHECK(VirtIOPONGCcw, (obj), TYPE_VIRTIO_PONG_CCW)
+
+typedef struct VirtIOPONGCcw {
+    VirtioCcwDevice parent_obj;
+    VirtIOPONG vdev;
+} VirtIOPONGCcw;
+
 /* virtio-crypto-ccw */
 
 #define TYPE_VIRTIO_CRYPTO_CCW "virtio-crypto-ccw"
diff --git a/hw/virtio/Kconfig b/hw/virtio/Kconfig
index 35ab45e209..f73c87d953 100644
--- a/hw/virtio/Kconfig
+++ b/hw/virtio/Kconfig
@@ -4,6 +4,11 @@ config VHOST
 config VIRTIO
     bool
 
+config VIRTIO_PONG
+    bool
+    default y
+    depends on VIRTIO
+
 config VIRTIO_RNG
     bool
     default y
diff --git a/hw/virtio/meson.build b/hw/virtio/meson.build
index bc352a6009..1ba4dcc454 100644
--- a/hw/virtio/meson.build
+++ b/hw/virtio/meson.build
@@ -6,6 +6,7 @@ softmmu_virtio_ss.add(when: 'CONFIG_VHOST', if_false: files('vhost-stub.c'))
 
 softmmu_ss.add_all(when: 'CONFIG_VIRTIO', if_true: softmmu_virtio_ss)
 softmmu_ss.add(when: 'CONFIG_VIRTIO', if_false: files('vhost-stub.c'))
+softmmu_ss.add(when: 'CONFIG_VIRTIO', if_true: files('virtio-pong.c'))
 
 softmmu_ss.add(when: 'CONFIG_ALL', if_true: files('vhost-stub.c'))
 
diff --git a/hw/virtio/virtio-pong.c b/hw/virtio/virtio-pong.c
new file mode 100644
index 0000000000..c15100dd43
--- /dev/null
+++ b/hw/virtio/virtio-pong.c
@@ -0,0 +1,161 @@
+/*
+ * A virtio device implementing a PONG device
+ *
+ * Copyright 2020 IBM.
+ * Copyright 2020 Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * (at your option) any later version.  See the COPYING file in the
+ * top-level directory.
+ */
+
+#include "qemu/osdep.h"
+#include "qapi/error.h"
+#include "qemu/iov.h"
+#include "qemu/module.h"
+#include "sysemu/runstate.h"
+#include "hw/virtio/virtio.h"
+#include "hw/qdev-properties.h"
+#include "standard-headers/linux/virtio_ids.h"
+#include "hw/virtio/virtio-pong.h"
+#include "qom/object_interfaces.h"
+#include "trace.h"
+#include "qemu/error-report.h"
+
+static char *buffer;
+static unsigned int cksum;
+
+static unsigned int simple_checksum(char *buf, unsigned long len)
+{
+    unsigned int sum = 0;
+
+    while (len--) {
+        sum += *buf * *buf + 7 * *buf + 3;
+        buf++;
+    }
+    return sum;
+}
+
+static void handle_output(VirtIODevice *vdev, VirtQueue *vq)
+{
+    VirtIOPONG *vpong = VIRTIO_PONG(vdev);
+    VirtQueueElement *elem;
+
+    if (!virtio_queue_ready(vq)) {
+        return;
+    }
+    if (virtio_queue_empty(vq)) {
+        return;
+    }
+
+    while ((elem = virtqueue_pop(vq, sizeof(*elem))) != NULL) {
+        buffer = g_malloc(elem->out_sg->iov_len);
+        iov_to_buf(elem->out_sg, elem->out_num, 0, buffer,
+                   elem->out_sg->iov_len);
+
+        if (vpong->cksum) {
+            cksum = simple_checksum(buffer, elem->out_sg->iov_len);
+        }
+        virtqueue_push(vq, elem, 0);
+        g_free(buffer);
+        g_free(elem);
+    }
+
+    virtio_notify(vdev, vq);
+}
+
+static void handle_input(VirtIODevice *vdev, VirtQueue *vq)
+{
+    VirtQueueElement *elem;
+
+    if (!virtio_queue_ready(vq)) {
+        return;
+    }
+    if (virtio_queue_empty(vq)) {
+        return;
+    }
+
+    while ((elem = virtqueue_pop(vq, sizeof(*elem))) != NULL) {
+        int len = 0;
+
+        len = iov_from_buf(elem->out_sg, elem->out_num,
+                         0, &cksum, sizeof(cksum));
+
+        virtqueue_push(vq, elem, len);
+        g_free(elem);
+    }
+
+    virtio_notify(vdev, vq);
+
+}
+
+static uint64_t get_features(VirtIODevice *vdev, uint64_t f, Error **errp)
+{
+    VirtIOPONG *vpong = VIRTIO_PONG(vdev);
+
+    if (vpong->cksum) {
+        f |= 1ull << VIRTIO_PONG_F_CKSUM;
+    }
+    return f;
+}
+
+static void virtio_pong_set_status(VirtIODevice *vdev, uint8_t status)
+{
+    if (!vdev->vm_running) {
+        return;
+    }
+    vdev->status = status;
+}
+
+static void virtio_pong_device_realize(DeviceState *dev, Error **errp)
+{
+    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
+    VirtIOPONG *vpong = VIRTIO_PONG(dev);
+
+    virtio_init(vdev, "virtio-pong", VIRTIO_ID_PONG, 0);
+
+    vpong->vq_in = virtio_add_queue(vdev, 8, handle_input);
+    vpong->vq_out = virtio_add_queue(vdev, 8, handle_output);
+}
+
+static void virtio_pong_device_unrealize(DeviceState *dev)
+{
+    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
+    VirtIOPONG *vpong = VIRTIO_PONG(dev);
+
+    qemu_del_vm_change_state_handler(vpong->vmstate);
+    virtio_del_queue(vdev, 0);
+    virtio_cleanup(vdev);
+}
+
+static Property virtio_pong_properties[] = {
+    DEFINE_PROP_UINT64("cksum", VirtIOPONG, cksum, 1),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static void virtio_pong_class_init(ObjectClass *klass, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(klass);
+    VirtioDeviceClass *vdc = VIRTIO_DEVICE_CLASS(klass);
+
+    device_class_set_props(dc, virtio_pong_properties);
+    set_bit(DEVICE_CATEGORY_MISC, dc->categories);
+    vdc->realize = virtio_pong_device_realize;
+    vdc->unrealize = virtio_pong_device_unrealize;
+    vdc->get_features = get_features;
+    vdc->set_status = virtio_pong_set_status;
+}
+
+static const TypeInfo virtio_pong_info = {
+    .name = TYPE_VIRTIO_PONG,
+    .parent = TYPE_VIRTIO_DEVICE,
+    .instance_size = sizeof(VirtIOPONG),
+    .class_init = virtio_pong_class_init,
+};
+
+static void virtio_register_types(void)
+{
+    type_register_static(&virtio_pong_info);
+}
+
+type_init(virtio_register_types)
diff --git a/include/hw/virtio/virtio-pong.h b/include/hw/virtio/virtio-pong.h
new file mode 100644
index 0000000000..ff44f2fead
--- /dev/null
+++ b/include/hw/virtio/virtio-pong.h
@@ -0,0 +1,34 @@
+/*
+ * Virtio PONG Support
+ *
+ * Copyright IBM 2020
+ * Copyright Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * (at your option) any later version.  See the COPYING file in the
+ * top-level directory.
+ */
+
+#ifndef QEMU_VIRTIO_PONG_H
+#define QEMU_VIRTIO_PONG_H
+
+#include "hw/virtio/virtio.h"
+
+#define TYPE_VIRTIO_PONG "virtio-pong-device"
+#define VIRTIO_PONG(obj) \
+        OBJECT_CHECK(VirtIOPONG, (obj), TYPE_VIRTIO_PONG)
+#define VIRTIO_PONG_GET_PARENT_CLASS(obj) \
+        OBJECT_GET_PARENT_CLASS(obj, TYPE_VIRTIO_PONG)
+
+typedef struct VirtIOPONG {
+    VirtIODevice parent_obj;
+    VirtQueue *vq_in;
+    VirtQueue *vq_out;
+    VMChangeStateEntry *vmstate;
+    uint64_t cksum;
+} VirtIOPONG;
+
+/* Feature bits */
+#define VIRTIO_PONG_F_CKSUM    1       /* Indicates pong using checksum */
+
+#endif
-- 
2.25.1

