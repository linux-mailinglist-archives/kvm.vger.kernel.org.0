Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A677D4D8D51
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244702AbiCNTwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244565AbiCNTwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:52:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CC326FD
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:50:40 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlXQ3005110;
        Mon, 14 Mar 2022 19:49:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YbmNfifklOCLP3pb4sII09nI2ZUduYgn2qgGTlE0BOk=;
 b=WrC96QxIZxwGKLeWaKPboNp0HmVc8N3vf+kM7mXDd+T2s88kibJOD/TyZeVOmIwxKYZ5
 UY8z/8sW514qICvfMtxdsZYB8PYoadTycFmE/F/t0W2W6/mfFSDerBZC0QcGdtc8XVfz
 OR3X3j2DtvLZeS/kKxnrATqdm6oPjwsFLkaeUX6dE6Tr+ZrxsFOq6RTl3ykUzK8UfauS
 vRSKHLvK1rSdUB7oq4PGyloJFHw5sqaGJC65L2LlPK6kBAgeaQsvY0AR2tEz0FxyUU7E
 wRATDcsV9RNlcTqDkOPXbGcAlILxIRUt5naol/BoXqmaTp+Qf+xRKKeuERqM+d/B0+eu qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6af0wqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:58 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJms1S012077;
        Mon, 14 Mar 2022 19:49:57 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6af0wq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:57 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJl7dP004519;
        Mon, 14 Mar 2022 19:49:56 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 3erk59g7wt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:56 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJnsGu48562546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:49:54 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82A6F112071;
        Mon, 14 Mar 2022 19:49:54 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76984112062;
        Mon, 14 Mar 2022 19:49:49 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:49:49 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v4 05/11] s390x/pci: enable for load/store intepretation
Date:   Mon, 14 Mar 2022 15:49:14 -0400
Message-Id: <20220314194920.58888-6-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194920.58888-1-mjrosato@linux.ibm.com>
References: <20220314194920.58888-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bm26c9dmadsCSsp3xngyQ0QTQn0e15Ew
X-Proofpoint-ORIG-GUID: J1HdvGHYpYmTmnKikICy-KJBO9kXTFQv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the associated kvm ioctl to enable interpretation for devices
when requested.  As part of this process, we must use the host function
handle rather than a QEMU-generated one -- we use an initial value from
vfio CLP and maintain an updated fh value from kvm ioctl response info.

By default, unless interpret=off is specified, interpretation support will
always be assumed and exploited if the necessary ioctl and features are
available on the host kernel.  When these are unavailable, we will silently
revert to the interception model; this allows existing guest configurations
to work unmodified on hosts with and without zPCI interpretation support,
allowing QEMU to choose the best support model available.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/meson.build            |   1 +
 hw/s390x/s390-pci-bus.c         |  67 ++++++++++++++++++-
 hw/s390x/s390-pci-inst.c        |  54 ++++++++++++++-
 hw/s390x/s390-pci-kvm.c         | 112 ++++++++++++++++++++++++++++++++
 include/hw/s390x/s390-pci-bus.h |   1 +
 include/hw/s390x/s390-pci-kvm.h |  46 +++++++++++++
 target/s390x/kvm/kvm.c          |   7 ++
 target/s390x/kvm/kvm_s390x.h    |   1 +
 8 files changed, 287 insertions(+), 2 deletions(-)
 create mode 100644 hw/s390x/s390-pci-kvm.c
 create mode 100644 include/hw/s390x/s390-pci-kvm.h

diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
index 28484256ec..6e6e47fcda 100644
--- a/hw/s390x/meson.build
+++ b/hw/s390x/meson.build
@@ -23,6 +23,7 @@ s390x_ss.add(when: 'CONFIG_KVM', if_true: files(
   's390-skeys-kvm.c',
   's390-stattrib-kvm.c',
   'pv.c',
+  's390-pci-kvm.c',
 ))
 s390x_ss.add(when: 'CONFIG_TCG', if_true: files(
   'tod-tcg.c',
diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index 4b2bdd94b3..7ce7bda26d 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -16,6 +16,7 @@
 #include "qapi/visitor.h"
 #include "hw/s390x/s390-pci-bus.h"
 #include "hw/s390x/s390-pci-inst.h"
+#include "hw/s390x/s390-pci-kvm.h"
 #include "hw/s390x/s390-pci-vfio.h"
 #include "hw/pci/pci_bus.h"
 #include "hw/qdev-properties.h"
@@ -971,12 +972,45 @@ static void s390_pci_update_subordinate(PCIDevice *dev, uint32_t nr)
     }
 }
 
+static int s390_pci_interp_plug(S390pciState *s, S390PCIBusDevice *pbdev)
+{
+    uint32_t idx;
+    int rc;
+
+    rc = s390_pci_kvm_plug(pbdev);
+    if (rc) {
+        return rc;
+    }
+
+    /* Next, see if the idx is already in-use */
+    idx = pbdev->fh & FH_MASK_INDEX;
+    if (pbdev->idx != idx) {
+        if (s390_pci_find_dev_by_idx(s, idx)) {
+            return -EINVAL;
+        }
+        /*
+         * Update the idx entry with the passed through idx
+         * If the relinquished idx is lower than next_idx, use it
+         * to replace next_idx
+         */
+        g_hash_table_remove(s->zpci_table, &pbdev->idx);
+        if (idx < s->next_idx) {
+            s->next_idx = idx;
+        }
+        pbdev->idx = idx;
+        g_hash_table_insert(s->zpci_table, &pbdev->idx, pbdev);
+    }
+
+    return 0;
+}
+
 static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
                               Error **errp)
 {
     S390pciState *s = S390_PCI_HOST_BRIDGE(hotplug_dev);
     PCIDevice *pdev = NULL;
     S390PCIBusDevice *pbdev = NULL;
+    int rc;
 
     if (object_dynamic_cast(OBJECT(dev), TYPE_PCI_BRIDGE)) {
         PCIBridge *pb = PCI_BRIDGE(dev);
@@ -1022,12 +1056,35 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
         set_pbdev_info(pbdev);
 
         if (object_dynamic_cast(OBJECT(dev), "vfio-pci")) {
-            pbdev->fh |= FH_SHM_VFIO;
+            /*
+             * By default, interpretation is always requested; if the available
+             * facilities indicate it is not available, fallback to the
+             * interception model.
+             */
+            if (pbdev->interp) {
+                if (s390_pci_kvm_zpciop_allowed()) {
+                    rc = s390_pci_interp_plug(s, pbdev);
+                    if (rc) {
+                        error_setg(errp, "Plug failed for zPCI device in "
+                                   "interpretation mode: %d", rc);
+                        return;
+                    }
+                } else {
+                    DPRINTF("zPCI interpretation facilities missing.\n");
+                    pbdev->interp = false;
+                }
+            }
             pbdev->iommu->dma_limit = s390_pci_start_dma_count(s, pbdev);
             /* Fill in CLP information passed via the vfio region */
             s390_pci_get_clp_info(pbdev);
+            if (!pbdev->interp) {
+                /* Do vfio passthrough but intercept for I/O */
+                pbdev->fh |= FH_SHM_VFIO;
+            }
         } else {
             pbdev->fh |= FH_SHM_EMUL;
+            /* Always intercept emulated devices */
+            pbdev->interp = false;
         }
 
         if (s390_pci_msix_init(pbdev)) {
@@ -1078,6 +1135,8 @@ static void s390_pcihost_unplug(HotplugHandler *hotplug_dev, DeviceState *dev,
         pbdev->pdev = NULL;
         pbdev->state = ZPCI_FS_RESERVED;
     } else if (object_dynamic_cast(OBJECT(dev), TYPE_S390_PCI_DEVICE)) {
+        int rc;
+
         pbdev = S390_PCI_DEVICE(dev);
         pbdev->fid = 0;
         QTAILQ_REMOVE(&s->zpci_devs, pbdev, link);
@@ -1085,6 +1144,11 @@ static void s390_pcihost_unplug(HotplugHandler *hotplug_dev, DeviceState *dev,
         if (pbdev->iommu->dma_limit) {
             s390_pci_end_dma_count(s, pbdev->iommu->dma_limit);
         }
+        rc = s390_pci_kvm_unplug(pbdev);
+        if (rc) {
+            error_setg(errp, "Unplug failed for zPCI device in interpretation "
+                       "mode rc=%d", rc);
+        }
         qdev_unrealize(dev);
     }
 }
@@ -1360,6 +1424,7 @@ static Property s390_pci_device_properties[] = {
     DEFINE_PROP_UINT16("uid", S390PCIBusDevice, uid, UID_UNDEFINED),
     DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
     DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
+    DEFINE_PROP_BOOL("interpret", S390PCIBusDevice, interp, true),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
index 6d400d4147..92ea7b73e4 100644
--- a/hw/s390x/s390-pci-inst.c
+++ b/hw/s390x/s390-pci-inst.c
@@ -18,6 +18,8 @@
 #include "sysemu/hw_accel.h"
 #include "hw/s390x/s390-pci-inst.h"
 #include "hw/s390x/s390-pci-bus.h"
+#include "hw/s390x/s390-pci-kvm.h"
+#include "hw/s390x/s390-pci-vfio.h"
 #include "hw/s390x/tod.h"
 
 #ifndef DEBUG_S390PCI_INST
@@ -156,6 +158,37 @@ out:
     return rc;
 }
 
+static int clp_enable_interp(S390PCIBusDevice *pbdev)
+{
+    int rc;
+
+    rc = s390_pci_kvm_interp_enable(pbdev);
+    if (rc) {
+        DPRINTF("Failed to enable interpretation\n");
+        return rc;
+    }
+
+    if (!(pbdev->fh & FH_MASK_ENABLE)) {
+        DPRINTF("Passthrough handle is not enabled\n");
+        return -EINVAL;
+    }
+
+    return 0;
+}
+
+static int clp_disable_interp(S390PCIBusDevice *pbdev)
+{
+    int rc;
+
+    rc = s390_pci_kvm_interp_disable(pbdev);
+    if (rc) {
+        DPRINTF("Failed to disable interpretation\n");
+        return rc;
+    }
+
+    return 0;
+}
+
 int clp_service_call(S390CPU *cpu, uint8_t r2, uintptr_t ra)
 {
     ClpReqHdr *reqh;
@@ -246,7 +279,19 @@ int clp_service_call(S390CPU *cpu, uint8_t r2, uintptr_t ra)
                 goto out;
             }
 
-            pbdev->fh |= FH_MASK_ENABLE;
+            /*
+             * If interpretation is specified, attempt to enable this now and
+             * update with the host fh
+             */
+            if (pbdev->interp) {
+                if (clp_enable_interp(pbdev)) {
+                    stw_p(&ressetpci->hdr.rsp, CLP_RC_SETPCIFN_ERR);
+                    goto out;
+                }
+            } else {
+                pbdev->fh |= FH_MASK_ENABLE;
+            }
+
             pbdev->state = ZPCI_FS_ENABLED;
             stl_p(&ressetpci->fh, pbdev->fh);
             stw_p(&ressetpci->hdr.rsp, CLP_RC_OK);
@@ -257,6 +302,13 @@ int clp_service_call(S390CPU *cpu, uint8_t r2, uintptr_t ra)
                 goto out;
             }
             device_legacy_reset(DEVICE(pbdev));
+            if (pbdev->interp) {
+                if (clp_disable_interp(pbdev)) {
+                    stw_p(&ressetpci->hdr.rsp, CLP_RC_SETPCIFN_ERR);
+                    goto out;
+                }
+            }
+            /* Mask off the enabled bit for interpreted devices too */
             pbdev->fh &= ~FH_MASK_ENABLE;
             pbdev->state = ZPCI_FS_DISABLED;
             stl_p(&ressetpci->fh, pbdev->fh);
diff --git a/hw/s390x/s390-pci-kvm.c b/hw/s390x/s390-pci-kvm.c
new file mode 100644
index 0000000000..755ea0618a
--- /dev/null
+++ b/hw/s390x/s390-pci-kvm.c
@@ -0,0 +1,112 @@
+/*
+ * s390 zPCI KVM interfaces
+ *
+ * Copyright 2022 IBM Corp.
+ * Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+
+#include "qemu/osdep.h"
+
+#include <linux/kvm.h>
+
+#include "kvm/kvm_s390x.h"
+#include "hw/s390x/s390-pci-bus.h"
+#include "hw/s390x/s390-pci-kvm.h"
+#include "hw/s390x/s390-pci-vfio.h"
+
+bool s390_pci_kvm_zpciop_allowed(void)
+{
+    return s390_has_feat(S390_FEAT_ZPCI_INTERP) && kvm_s390_get_zpci_op();
+}
+
+int s390_pci_kvm_plug(S390PCIBusDevice *pbdev)
+{
+    int rc;
+
+    struct kvm_s390_zpci_op args = {
+        .op = KVM_S390_ZPCIOP_INIT
+    };
+
+    if (!s390_pci_get_host_fh(pbdev, &args.fh)) {
+        return -EINVAL;
+    }
+
+    rc = kvm_vm_ioctl(kvm_state, KVM_S390_ZPCI_OP, &args);
+    if (!rc) {
+        /*
+         * The host device is already in an enabled state, but we always present
+         * the initial device state to the guest as disabled (ZPCI_FS_DISABLED).
+         * Therefore, mask off the enable bit from the passthrough handle until
+         * the guest issues a CLP SET PCI FN later to enable the device.
+         */
+        pbdev->fh = (args.newfh & ~FH_MASK_ENABLE);
+    }
+
+    return rc;
+}
+
+int s390_pci_kvm_unplug(S390PCIBusDevice *pbdev)
+{
+    struct kvm_s390_zpci_op args = {
+        .fh = pbdev->fh | FH_MASK_ENABLE,
+        .op = KVM_S390_ZPCIOP_END
+    };
+
+    return kvm_vm_ioctl(kvm_state, KVM_S390_ZPCI_OP, &args);
+}
+
+int s390_pci_kvm_interp_enable(S390PCIBusDevice *pbdev)
+{
+    uint32_t fh;
+    int rc;
+
+    struct kvm_s390_zpci_op args = {
+        .fh = pbdev->fh | FH_MASK_ENABLE,
+        .op = KVM_S390_ZPCIOP_START_INTERP
+    };
+
+ retry:
+    rc = kvm_vm_ioctl(kvm_state, KVM_S390_ZPCI_OP, &args);
+
+    if (rc == -ENODEV) {
+        /*
+         * If the function wasn't found, re-sync the function handle with vfio
+         * and if a change is detected, retry the operation with the new fh.
+         * This can happen while the device is disabled to the guest due to
+         * vfio-triggered events (e.g. vfio hot reset for ISM during plug)
+         */
+        if (!s390_pci_get_host_fh(pbdev, &fh)) {
+            return -EINVAL;
+        }
+        if (fh != args.fh) {
+            args.fh = fh;
+            goto retry;
+        }
+    }
+    if (!rc) {
+        pbdev->fh = args.newfh;
+    }
+
+    return rc;
+}
+
+int s390_pci_kvm_interp_disable(S390PCIBusDevice *pbdev)
+{
+    int rc;
+
+    struct kvm_s390_zpci_op args = {
+        .fh = pbdev->fh,
+        .op = KVM_S390_ZPCIOP_STOP_INTERP
+    };
+
+    rc = kvm_vm_ioctl(kvm_state, KVM_S390_ZPCI_OP, &args);
+    if (!rc) {
+        pbdev->fh = args.newfh;
+    }
+
+    return rc;
+}
diff --git a/include/hw/s390x/s390-pci-bus.h b/include/hw/s390x/s390-pci-bus.h
index da3cde2bb4..a9843dfe97 100644
--- a/include/hw/s390x/s390-pci-bus.h
+++ b/include/hw/s390x/s390-pci-bus.h
@@ -350,6 +350,7 @@ struct S390PCIBusDevice {
     IndAddr *indicator;
     bool pci_unplug_request_processed;
     bool unplug_requested;
+    bool interp;
     QTAILQ_ENTRY(S390PCIBusDevice) link;
 };
 
diff --git a/include/hw/s390x/s390-pci-kvm.h b/include/hw/s390x/s390-pci-kvm.h
new file mode 100644
index 0000000000..6b2528cf82
--- /dev/null
+++ b/include/hw/s390x/s390-pci-kvm.h
@@ -0,0 +1,46 @@
+/*
+ * s390 PCI KVM interfaces
+ *
+ * Copyright 2022 IBM Corp.
+ * Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+
+#ifndef HW_S390_PCI_KVM_H
+#define HW_S390_PCI_KVM_H
+
+#include "hw/s390x/s390-pci-bus.h"
+
+#ifdef CONFIG_KVM
+bool s390_pci_kvm_zpciop_allowed(void);
+int s390_pci_kvm_plug(S390PCIBusDevice *pbdev);
+int s390_pci_kvm_unplug(S390PCIBusDevice *pbdev);
+int s390_pci_kvm_interp_enable(S390PCIBusDevice *pbdev);
+int s390_pci_kvm_interp_disable(S390PCIBusDevice *pbdev);
+#else
+static inline bool s390_pci_kvm_zpciop_allowed(void)
+{
+    return false;
+}
+static inline int s390_pci_kvm_plug(S390PCIBusDevice *pbdev)
+{
+    return -EINVAL;
+}
+static inline int s390_pci_kvm_unplug(S390PCIBusDevice *pbdev)
+{
+    return -EINVAL;
+}
+static inline int s390_pci_kvm_interp_enable(S390PCIBusDevice *pbdev)
+{
+    return -EINVAL;
+}
+static inline int s390_pci_kvm_interp_enable(S390PCIBusDevice *pbdev)
+{
+    return -EINVAL;
+}
+#endif
+
+#endif
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 0357bfda89..288fbd1d75 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -157,6 +157,7 @@ static int cap_ri;
 static int cap_hpage_1m;
 static int cap_vcpu_resets;
 static int cap_protected;
+static int cap_zpci_op;
 
 static int active_cmma;
 
@@ -358,6 +359,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     cap_s390_irq = kvm_check_extension(s, KVM_CAP_S390_INJECT_IRQ);
     cap_vcpu_resets = kvm_check_extension(s, KVM_CAP_S390_VCPU_RESETS);
     cap_protected = kvm_check_extension(s, KVM_CAP_S390_PROTECTED);
+    cap_zpci_op = kvm_check_extension(s, KVM_CAP_S390_ZPCI_OP);
 
     kvm_vm_enable_cap(s, KVM_CAP_S390_USER_SIGP, 0);
     kvm_vm_enable_cap(s, KVM_CAP_S390_VECTOR_REGISTERS, 0);
@@ -2567,3 +2569,8 @@ bool kvm_arch_cpu_check_are_resettable(void)
 {
     return true;
 }
+
+int kvm_s390_get_zpci_op(void)
+{
+    return cap_zpci_op;
+}
diff --git a/target/s390x/kvm/kvm_s390x.h b/target/s390x/kvm/kvm_s390x.h
index 05a5e1e6f4..aaae8570de 100644
--- a/target/s390x/kvm/kvm_s390x.h
+++ b/target/s390x/kvm/kvm_s390x.h
@@ -27,6 +27,7 @@ void kvm_s390_vcpu_interrupt_pre_save(S390CPU *cpu);
 int kvm_s390_vcpu_interrupt_post_load(S390CPU *cpu);
 int kvm_s390_get_hpage_1m(void);
 int kvm_s390_get_ri(void);
+int kvm_s390_get_zpci_op(void);
 int kvm_s390_get_clock(uint8_t *tod_high, uint64_t *tod_clock);
 int kvm_s390_get_clock_ext(uint8_t *tod_high, uint64_t *tod_clock);
 int kvm_s390_set_clock(uint8_t tod_high, uint64_t tod_clock);
-- 
2.27.0

