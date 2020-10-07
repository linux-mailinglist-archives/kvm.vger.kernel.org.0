Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9FF286809
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 21:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgJGTFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 15:05:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62454 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728254AbgJGTFI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 15:05:08 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 097J0w62011590;
        Wed, 7 Oct 2020 15:04:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=rxJHrrGwAH95cY5t0BsFMeQVPmQ3iOx4VAt7Ysr6bQo=;
 b=onEl4cDen+szUHy0V0JgOmCMufnVfAxptQnsnPDh4CnUcqHls+0Pxx11OvI1QgWNqwAr
 41antznkrEZJ23QO357EeCoX1kbGMZLSMzsOfw0rm/TpGSHB7kZrmrf9CIXRdktM5sl6
 hnDqZ3TBfm4jBsmfzT2jsFGbgPHyiT80LcNxShX99yXRr58JIVhLaQnLUOhAESZiG/nU
 Xbzqt8blKeuFjyU8TAUhnIdHKyBQcL0NwYeqK4YO/OvkO2HitAXSAhX4gUQ2K+3o8czl
 OE4L0aHkGUzsds5IiM2zqbMks7xXd3EvKwNz3c6Ha42hF2zms/UuzPY7G7DHTI09SRpX aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 341jehswua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 15:04:48 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 097J11xi011814;
        Wed, 7 Oct 2020 15:04:48 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 341jehswu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 15:04:48 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 097IlXgV003114;
        Wed, 7 Oct 2020 19:04:47 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03dal.us.ibm.com with ESMTP id 33xgx9spcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 19:04:47 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 097J4kQr40894830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Oct 2020 19:04:46 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83634AC05B;
        Wed,  7 Oct 2020 19:04:46 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25D47AC05E;
        Wed,  7 Oct 2020 19:04:44 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.60.106])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  7 Oct 2020 19:04:43 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     cohuck@redhat.com, thuth@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v3 10/10] s390x/pci: get zPCI function info from host
Date:   Wed,  7 Oct 2020 15:04:15 -0400
Message-Id: <1602097455-15658-11-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602097455-15658-1-git-send-email-mjrosato@linux.ibm.com>
References: <1602097455-15658-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=2 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070118
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We use the capability chains of the VFIO_DEVICE_GET_INFO ioctl to retrieve
the CLP information that the kernel exports.

To be compatible with previous kernel versions we fall back on previous
predefined values, same as the emulation values, when the ioctl is found
to not support capability chains. If individual CLP capabilities are not
found, we fall back on default values for only those capabilities missing
from the chain.

This patch is based on work previously done by Pierre Morel.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/meson.build             |   1 +
 hw/s390x/s390-pci-bus.c          |  10 +-
 hw/s390x/s390-pci-vfio.c         | 197 +++++++++++++++++++++++++++++++++++++++
 include/hw/s390x/s390-pci-bus.h  |   1 +
 include/hw/s390x/s390-pci-clp.h  |  12 ++-
 include/hw/s390x/s390-pci-vfio.h |  19 ++++
 6 files changed, 233 insertions(+), 7 deletions(-)
 create mode 100644 hw/s390x/s390-pci-vfio.c
 create mode 100644 include/hw/s390x/s390-pci-vfio.h

diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
index 948ceae..3ee4594 100644
--- a/hw/s390x/meson.build
+++ b/hw/s390x/meson.build
@@ -10,6 +10,7 @@ s390x_ss.add(files(
   's390-ccw.c',
   's390-pci-bus.c',
   's390-pci-inst.c',
+  's390-pci-vfio.c',
   's390-skeys.c',
   's390-stattrib.c',
   's390-virtio-hcall.c',
diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index 3dc8a10..182e76e 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -17,6 +17,7 @@
 #include "cpu.h"
 #include "hw/s390x/s390-pci-bus.h"
 #include "hw/s390x/s390-pci-inst.h"
+#include "hw/s390x/s390-pci-vfio.h"
 #include "hw/pci/pci_bus.h"
 #include "hw/qdev-properties.h"
 #include "hw/pci/pci_bridge.h"
@@ -737,7 +738,7 @@ static void s390_pci_iommu_free(S390pciState *s, PCIBus *bus, int32_t devfn)
     object_unref(OBJECT(iommu));
 }
 
-static S390PCIGroup *s390_group_create(int id)
+S390PCIGroup *s390_group_create(int id)
 {
     S390PCIGroup *group;
     S390pciState *s = s390_get_phb();
@@ -782,7 +783,7 @@ static void set_pbdev_info(S390PCIBusDevice *pbdev)
     pbdev->zpci_fn.sdma = ZPCI_SDMA_ADDR;
     pbdev->zpci_fn.edma = ZPCI_EDMA_ADDR;
     pbdev->zpci_fn.pchid = 0;
-    pbdev->zpci_fn.ug = ZPCI_DEFAULT_FN_GRP;
+    pbdev->zpci_fn.pfgid = ZPCI_DEFAULT_FN_GRP;
     pbdev->zpci_fn.fid = pbdev->fid;
     pbdev->zpci_fn.uid = pbdev->uid;
     pbdev->pci_group = s390_group_find(ZPCI_DEFAULT_FN_GRP);
@@ -861,7 +862,8 @@ static int s390_pci_msix_init(S390PCIBusDevice *pbdev)
     name = g_strdup_printf("msix-s390-%04x", pbdev->uid);
     memory_region_init_io(&pbdev->msix_notify_mr, OBJECT(pbdev),
                           &s390_msi_ctrl_ops, pbdev, name, PAGE_SIZE);
-    memory_region_add_subregion(&pbdev->iommu->mr, ZPCI_MSI_ADDR,
+    memory_region_add_subregion(&pbdev->iommu->mr,
+                                pbdev->pci_group->zpci_group.msia,
                                 &pbdev->msix_notify_mr);
     g_free(name);
 
@@ -1013,6 +1015,8 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
 
         if (object_dynamic_cast(OBJECT(dev), "vfio-pci")) {
             pbdev->fh |= FH_SHM_VFIO;
+            /* Fill in CLP information passed via the vfio region */
+            s390_pci_get_clp_info(pbdev);
         } else {
             pbdev->fh |= FH_SHM_EMUL;
         }
diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
new file mode 100644
index 0000000..43684c6
--- /dev/null
+++ b/hw/s390x/s390-pci-vfio.c
@@ -0,0 +1,197 @@
+/*
+ * s390 vfio-pci interfaces
+ *
+ * Copyright 2020 IBM Corp.
+ * Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+
+#include <sys/ioctl.h>
+#include <linux/vfio.h>
+#include <linux/vfio_zdev.h>
+
+#include "qemu/osdep.h"
+#include "hw/s390x/s390-pci-bus.h"
+#include "hw/s390x/s390-pci-clp.h"
+#include "hw/s390x/s390-pci-vfio.h"
+#include "hw/vfio/pci.h"
+
+#ifndef DEBUG_S390PCI_VFIO
+#define DEBUG_S390PCI_VFIO  0
+#endif
+
+#define DPRINTF(fmt, ...)                                          \
+    do {                                                           \
+        if (DEBUG_S390PCI_VFIO) {                                  \
+            fprintf(stderr, "S390pci-vfio: " fmt, ## __VA_ARGS__); \
+        }                                                          \
+    } while (0)
+
+static void s390_pci_read_base(S390PCIBusDevice *pbdev,
+                               struct vfio_device_info *info)
+{
+    struct vfio_info_cap_header *hdr;
+    struct vfio_device_info_cap_zpci_base *cap;
+
+    hdr = vfio_get_device_info_cap(info, VFIO_DEVICE_INFO_CAP_ZPCI_BASE);
+
+    /* If capability not provided, just leave the defaults in place */
+    if (hdr == NULL) {
+        DPRINTF("Base PCI clp capability not found\n");
+        return;
+    }
+    cap = (void *) hdr;
+
+    pbdev->zpci_fn.sdma = cap->start_dma;
+    pbdev->zpci_fn.edma = cap->end_dma;
+    pbdev->zpci_fn.pchid = cap->pchid;
+    pbdev->zpci_fn.vfn = cap->vfn;
+    pbdev->zpci_fn.pfgid = cap->gid;
+    /* The following values remain 0 until we support other FMB formats */
+    pbdev->zpci_fn.fmbl = 0;
+    pbdev->zpci_fn.pft = 0;
+}
+
+static void s390_pci_read_group(S390PCIBusDevice *pbdev,
+                                struct vfio_device_info *info)
+{
+    struct vfio_info_cap_header *hdr;
+    struct vfio_device_info_cap_zpci_group *cap;
+    ClpRspQueryPciGrp *resgrp;
+
+    hdr = vfio_get_device_info_cap(info, VFIO_DEVICE_INFO_CAP_ZPCI_GROUP);
+
+    /* If capability not provided, just use the default group */
+    if (hdr == NULL) {
+        DPRINTF("Base PCI Group clp capability not found\n");
+        pbdev->zpci_fn.pfgid = ZPCI_DEFAULT_FN_GRP;
+        pbdev->pci_group = s390_group_find(ZPCI_DEFAULT_FN_GRP);
+        return;
+    }
+    cap = (void *) hdr;
+
+    /* See if the PCI group is already defined, create if not */
+    pbdev->pci_group = s390_group_find(pbdev->zpci_fn.pfgid);
+
+    if (!pbdev->pci_group) {
+        pbdev->pci_group = s390_group_create(pbdev->zpci_fn.pfgid);
+
+        resgrp = &pbdev->pci_group->zpci_group;
+        if (cap->flags & VFIO_DEVICE_INFO_ZPCI_FLAG_REFRESH) {
+            resgrp->fr = 1;
+        }
+        stq_p(&resgrp->dasm, cap->dasm);
+        stq_p(&resgrp->msia, cap->msi_addr);
+        stw_p(&resgrp->mui, cap->mui);
+        stw_p(&resgrp->i, cap->noi);
+        stw_p(&resgrp->maxstbl, cap->maxstbl);
+        stb_p(&resgrp->version, cap->version);
+    }
+}
+
+static void s390_pci_read_util(S390PCIBusDevice *pbdev,
+                               struct vfio_device_info *info)
+{
+    struct vfio_info_cap_header *hdr;
+    struct vfio_device_info_cap_zpci_util *cap;
+
+    hdr = vfio_get_device_info_cap(info, VFIO_DEVICE_INFO_CAP_ZPCI_UTIL);
+
+    /* If capability not provided, just leave the defaults in place */
+    if (hdr == NULL) {
+        DPRINTF("Util clp capability not found\n");
+        return;
+    }
+    cap = (void *) hdr;
+
+    if (cap->size > CLP_UTIL_STR_LEN) {
+        DPRINTF("UTIL clp capability unexpected size\n");
+        return;
+    }
+
+    pbdev->zpci_fn.flags |= CLP_RSP_QPCI_MASK_UTIL;
+    memcpy(pbdev->zpci_fn.util_str, cap->util_str, CLP_UTIL_STR_LEN);
+}
+
+static void s390_pci_read_pfip(S390PCIBusDevice *pbdev,
+                               struct vfio_device_info *info)
+{
+    struct vfio_info_cap_header *hdr;
+    struct vfio_device_info_cap_zpci_pfip *cap;
+
+    hdr = vfio_get_device_info_cap(info, VFIO_DEVICE_INFO_CAP_ZPCI_PFIP);
+
+    /* If capability not provided, just leave the defaults in place */
+    if (hdr == NULL) {
+        DPRINTF("PFIP clp capability not found\n");
+        return;
+    }
+    cap = (void *) hdr;
+
+    if (cap->size > CLP_PFIP_NR_SEGMENTS) {
+        DPRINTF("PFIP clp capability unexpected size\n");
+        return;
+    }
+
+    memcpy(pbdev->zpci_fn.pfip, cap->pfip, CLP_PFIP_NR_SEGMENTS);
+}
+
+/*
+ * This function will issue the VFIO_DEVICE_GET_INFO ioctl and look for
+ * capabilities that contain information about CLP features provided by the
+ * underlying host.
+ * On entry, defaults have already been placed into the guest CLP response
+ * buffers.  On exit, defaults will have been overwritten for any CLP features
+ * found in the capability chain; defaults will remain for any CLP features not
+ * found in the chain.
+ */
+void s390_pci_get_clp_info(S390PCIBusDevice *pbdev)
+{
+    g_autofree struct vfio_device_info *info;
+    VFIOPCIDevice *vfio_pci;
+    uint32_t argsz;
+    int fd;
+
+    argsz = sizeof(*info);
+    info = g_malloc0(argsz);
+
+    vfio_pci = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
+    fd = vfio_pci->vbasedev.fd;
+
+    /*
+     * If the specified argsz is not large enough to contain all capabilities
+     * it will be updated upon return from the ioctl.  Retry until we have
+     * a big enough buffer to hold the entire capability chain.  On error,
+     * just exit and rely on CLP defaults.
+     */
+retry:
+    info->argsz = argsz;
+
+    if (ioctl(fd, VFIO_DEVICE_GET_INFO, info)) {
+        DPRINTF("zPCI could not read vfio device info\n");
+        return;
+    }
+
+    if (info->argsz > argsz) {
+        argsz = info->argsz;
+        info = g_realloc(info, argsz);
+        goto retry;
+    }
+
+    /*
+     * Find the CLP features provided and fill in the guest CLP responses.
+     * Always call s390_pci_read_base first as information from this could
+     * determine which function group is used in s390_pci_read_group.
+     * For any feature not found, the default values will remain in the CLP
+     * response.
+     */
+    s390_pci_read_base(pbdev, info);
+    s390_pci_read_group(pbdev, info);
+    s390_pci_read_util(pbdev, info);
+    s390_pci_read_pfip(pbdev, info);
+
+    return;
+}
diff --git a/include/hw/s390x/s390-pci-bus.h b/include/hw/s390x/s390-pci-bus.h
index 79206be..945d5c1 100644
--- a/include/hw/s390x/s390-pci-bus.h
+++ b/include/hw/s390x/s390-pci-bus.h
@@ -314,6 +314,7 @@ typedef struct S390PCIGroup {
     int id;
     QTAILQ_ENTRY(S390PCIGroup) link;
 } S390PCIGroup;
+S390PCIGroup *s390_group_create(int id);
 S390PCIGroup *s390_group_find(int id);
 
 struct S390PCIBusDevice {
diff --git a/include/hw/s390x/s390-pci-clp.h b/include/hw/s390x/s390-pci-clp.h
index 3708acd..ea2b137 100644
--- a/include/hw/s390x/s390-pci-clp.h
+++ b/include/hw/s390x/s390-pci-clp.h
@@ -79,6 +79,7 @@ typedef struct ClpFhListEntry {
 #define CLP_SET_DISABLE_PCI_FN 1 /* Yes, 1 disables it */
 
 #define CLP_UTIL_STR_LEN 64
+#define CLP_PFIP_NR_SEGMENTS 4
 
 #define CLP_MASK_FMT 0xf0000000
 
@@ -120,14 +121,17 @@ typedef struct ClpRspQueryPci {
     uint32_t fmt;
     uint64_t reserved1;
     uint16_t vfn; /* virtual fn number */
-#define CLP_RSP_QPCI_MASK_UTIL  0x100
-#define CLP_RSP_QPCI_MASK_PFGID 0xff
-    uint16_t ug;
+#define CLP_RSP_QPCI_MASK_UTIL  0x01
+    uint8_t flags;
+    uint8_t pfgid;
     uint32_t fid; /* pci function id */
     uint8_t bar_size[PCI_BAR_COUNT];
     uint16_t pchid;
     uint32_t bar[PCI_BAR_COUNT];
-    uint64_t reserved2;
+    uint8_t pfip[CLP_PFIP_NR_SEGMENTS];
+    uint16_t reserved2;
+    uint8_t fmbl;
+    uint8_t pft;
     uint64_t sdma; /* start dma as */
     uint64_t edma; /* end dma as */
     uint32_t reserved3[11];
diff --git a/include/hw/s390x/s390-pci-vfio.h b/include/hw/s390x/s390-pci-vfio.h
new file mode 100644
index 0000000..f690dae
--- /dev/null
+++ b/include/hw/s390x/s390-pci-vfio.h
@@ -0,0 +1,19 @@
+/*
+ * s390 vfio-pci interfaces
+ *
+ * Copyright 2020 IBM Corp.
+ * Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+
+#ifndef HW_S390_PCI_VFIO_H
+#define HW_S390_PCI_VFIO_H
+
+#include "hw/s390x/s390-pci-bus.h"
+
+void s390_pci_get_clp_info(S390PCIBusDevice *pbdev);
+
+#endif
-- 
1.8.3.1

