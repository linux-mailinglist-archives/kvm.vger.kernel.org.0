Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C76F5AB77A
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 19:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236676AbiIBR16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 13:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235939AbiIBR1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 13:27:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C146B6DAF1
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 10:27:52 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 282GkUdD001054;
        Fri, 2 Sep 2022 17:27:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=F3USjL7oA3Gh9WcB9MkIv2copyn818KDCuWzMvEK494=;
 b=MXpUpRwcIZmqkKwjjjjhaWB3vNjNeCCRKX+yfX0BFuWCaJog15A8eCCx5sIGOfPtWica
 ZgLyfLH9uFAGPABwDejModoeAn6A7lZaTi6eVJ10rBdasONM2afmH4CvCRSDQuRLOXIz
 DA5fXhUa+bFWBJ3iAWr3L6mVRlAQkLd/nkVUWUljkm/flRFOSTp3Kie0QlJHvSBfEoxS
 ZfEcYym0B064Ita594+nVhX54yYsM0+Q9As7TPeR8fH1xf68F9ld1dSbdziqCFdQ47oa
 9UBCHBu8JnGSBQLteI5/vqagxLDQvlSDsI+26WsV6mFmB2Hy/02r3ysFBHlrMXj0079f GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbnn911vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 17:27:47 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 282GnMvH018090;
        Fri, 2 Sep 2022 17:27:46 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jbnn911uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 17:27:46 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 282HLD7g025818;
        Fri, 2 Sep 2022 17:27:45 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 3j7awa1cpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Sep 2022 17:27:45 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 282HRiid15794526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Sep 2022 17:27:44 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31F8A6E050;
        Fri,  2 Sep 2022 17:27:44 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD32D6E04E;
        Fri,  2 Sep 2022 17:27:42 +0000 (GMT)
Received: from li-2311da4c-2e09-11b2-a85c-c003041e9174.ibm.com.com (unknown [9.160.86.252])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  2 Sep 2022 17:27:42 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v8 3/8] s390x/pci: enable for load/store intepretation
Date:   Fri,  2 Sep 2022 13:27:32 -0400
Message-Id: <20220902172737.170349-4-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220902172737.170349-1-mjrosato@linux.ibm.com>
References: <20220902172737.170349-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jGfv1kB7uD1xffJCMLHpbL4B9wbyUH-H
X-Proofpoint-GUID: 21EmeYc8R2PBFZh5ye31dhOi_vLtreWq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-02_04,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209020080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the ZPCI_OP ioctl reports that is is available and usable, then the
underlying KVM host will enable load/store intepretation for any guest
device without a SHM bit in the guest function handle.  For a device that
will be using interpretation support, ensure the guest function handle
matches the host function handle; this value is re-checked every time the
guest issues a SET PCI FN to enable the guest device as it is the only
opportunity to reflect function handle changes.

By default, unless interpret=off is specified, interpretation support will
always be assumed and exploited if the necessary ioctl and features are
available on the host kernel.  When these are unavailable, we will silently
revert to the interception model; this allows existing guest configurations
to work unmodified on hosts with and without zPCI interpretation support,
allowing QEMU to choose the best support model available.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/meson.build            |  1 +
 hw/s390x/s390-pci-bus.c         | 66 ++++++++++++++++++++++++++++++++-
 hw/s390x/s390-pci-inst.c        | 16 ++++++++
 hw/s390x/s390-pci-kvm.c         | 22 +++++++++++
 include/hw/s390x/s390-pci-bus.h |  1 +
 include/hw/s390x/s390-pci-kvm.h | 24 ++++++++++++
 target/s390x/kvm/kvm.c          |  7 ++++
 target/s390x/kvm/kvm_s390x.h    |  1 +
 8 files changed, 137 insertions(+), 1 deletion(-)
 create mode 100644 hw/s390x/s390-pci-kvm.c
 create mode 100644 include/hw/s390x/s390-pci-kvm.h

diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
index feefe0717e..f291016fee 100644
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
index 4b2bdd94b3..156051e6e9 100644
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
@@ -971,12 +972,51 @@ static void s390_pci_update_subordinate(PCIDevice *dev, uint32_t nr)
     }
 }
 
+static int s390_pci_interp_plug(S390pciState *s, S390PCIBusDevice *pbdev)
+{
+    uint32_t idx, fh;
+
+    if (!s390_pci_get_host_fh(pbdev, &fh)) {
+        return -EPERM;
+    }
+
+    /*
+     * The host device is already in an enabled state, but we always present
+     * the initial device state to the guest as disabled (ZPCI_FS_DISABLED).
+     * Therefore, mask off the enable bit from the passthrough handle until
+     * the guest issues a CLP SET PCI FN later to enable the device.
+     */
+    pbdev->fh = fh & ~FH_MASK_ENABLE;
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
@@ -1022,12 +1062,35 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
         set_pbdev_info(pbdev);
 
         if (object_dynamic_cast(OBJECT(dev), "vfio-pci")) {
-            pbdev->fh |= FH_SHM_VFIO;
+            /*
+             * By default, interpretation is always requested; if the available
+             * facilities indicate it is not available, fallback to the
+             * interception model.
+             */
+            if (pbdev->interp) {
+                if (s390_pci_kvm_interp_allowed()) {
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
@@ -1360,6 +1423,7 @@ static Property s390_pci_device_properties[] = {
     DEFINE_PROP_UINT16("uid", S390PCIBusDevice, uid, UID_UNDEFINED),
     DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
     DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
+    DEFINE_PROP_BOOL("interpret", S390PCIBusDevice, interp, true),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
index 6d400d4147..651ec38635 100644
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
@@ -246,6 +248,20 @@ int clp_service_call(S390CPU *cpu, uint8_t r2, uintptr_t ra)
                 goto out;
             }
 
+            /*
+             * Take this opportunity to make sure we still have an accurate
+             * host fh.  It's possible part of the handle changed while the
+             * device was disabled to the guest (e.g. vfio hot reset for
+             * ISM during plug)
+             */
+            if (pbdev->interp) {
+                /* Take this opportunity to make sure we are sync'd with host */
+                if (!s390_pci_get_host_fh(pbdev, &pbdev->fh) ||
+                    !(pbdev->fh & FH_MASK_ENABLE)) {
+                    stw_p(&ressetpci->hdr.rsp, CLP_RC_SETPCIFN_FH);
+                    goto out;
+                }
+            }
             pbdev->fh |= FH_MASK_ENABLE;
             pbdev->state = ZPCI_FS_ENABLED;
             stl_p(&ressetpci->fh, pbdev->fh);
diff --git a/hw/s390x/s390-pci-kvm.c b/hw/s390x/s390-pci-kvm.c
new file mode 100644
index 0000000000..0f16104a74
--- /dev/null
+++ b/hw/s390x/s390-pci-kvm.c
@@ -0,0 +1,22 @@
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
+#include "kvm/kvm_s390x.h"
+#include "hw/s390x/pv.h"
+#include "hw/s390x/s390-pci-kvm.h"
+#include "cpu_models.h"
+
+bool s390_pci_kvm_interp_allowed(void)
+{
+    return kvm_s390_get_zpci_op() && !s390_is_pv();
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
index 0000000000..80a2e7d0ca
--- /dev/null
+++ b/include/hw/s390x/s390-pci-kvm.h
@@ -0,0 +1,24 @@
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
+#ifdef CONFIG_KVM
+bool s390_pci_kvm_interp_allowed(void);
+#else
+static inline bool s390_pci_kvm_interp_allowed(void)
+{
+    return false;
+}
+#endif
+
+#endif
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 7bd8db0e7b..6a8dbadf7e 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -157,6 +157,7 @@ static int cap_ri;
 static int cap_hpage_1m;
 static int cap_vcpu_resets;
 static int cap_protected;
+static int cap_zpci_op;
 
 static bool mem_op_storage_key_support;
 
@@ -362,6 +363,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     cap_s390_irq = kvm_check_extension(s, KVM_CAP_S390_INJECT_IRQ);
     cap_vcpu_resets = kvm_check_extension(s, KVM_CAP_S390_VCPU_RESETS);
     cap_protected = kvm_check_extension(s, KVM_CAP_S390_PROTECTED);
+    cap_zpci_op = kvm_check_extension(s, KVM_CAP_S390_ZPCI_OP);
 
     kvm_vm_enable_cap(s, KVM_CAP_S390_USER_SIGP, 0);
     kvm_vm_enable_cap(s, KVM_CAP_S390_VECTOR_REGISTERS, 0);
@@ -2574,3 +2576,8 @@ bool kvm_arch_cpu_check_are_resettable(void)
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
2.37.2

