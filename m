Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7BE29911C
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 16:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783988AbgJZPf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 11:35:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61986 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1783972AbgJZPfY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 11:35:24 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09QFXlLG087451;
        Mon, 26 Oct 2020 11:35:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=LbC1Xr7K3UOODdFSufz/XWJC1eoG6ob6eSuJFwaNzk0=;
 b=gXdmQByaAj+Md0TEHs2oo/gQ0lTcx0wbtW2+dPnI5gO4ZdYZavoPKEB3PsJJc/r2+oE2
 oXY9k+SlekL/AyrzVN7KrYa0DHFiJtTBoIXhpobPNTUlGkcjU3AVthfhW9hIJ+XR1Aav
 zachfOyLdIrCaiORnh2ezNuey0+acqGcQZ22tOy1zsku658gGz1nE/CXzHUvDzPEdT4b
 DupU8+HHoZgvgvjSmFicp4bD+kFweH2UhcILN1mCteiCZnEEbtZNwhyfXTAslsFMWfv9
 fX7b9A/8sRavyq70eILe6RG2sODQWV+bF1TIe/jkWKOxN6E9Xm4uLf/5zqVLxOSKEhD1 UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34dp3qarvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 11:35:16 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09QFYNtl090872;
        Mon, 26 Oct 2020 11:35:15 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34dp3qaruv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 11:35:15 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09QFIMfe023459;
        Mon, 26 Oct 2020 15:35:14 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 34cbw8vt1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 15:35:14 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09QFZEuo47251768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 15:35:14 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08C5E112061;
        Mon, 26 Oct 2020 15:35:14 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50C28112066;
        Mon, 26 Oct 2020 15:35:11 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.49.29])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 26 Oct 2020 15:35:11 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     cohuck@redhat.com, thuth@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        philmd@redhat.com, qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH 07/13] s390x/pci: Honor DMA limits set by vfio
Date:   Mon, 26 Oct 2020 11:34:35 -0400
Message-Id: <1603726481-31824-8-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603726481-31824-1-git-send-email-mjrosato@linux.ibm.com>
References: <1603726481-31824-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-26_08:2020-10-26,2020-10-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When an s390 guest is using lazy unmapping, it can result in a very
large number of oustanding DMA requests, far beyond the default
limit configured for vfio.  Let's track DMA usage similar to vfio
in the host, and trigger the guest to flush their DMA mappings
before vfio runs out.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 hw/s390x/s390-pci-bus.c          | 16 +++++++++-----
 hw/s390x/s390-pci-inst.c         | 45 ++++++++++++++++++++++++++++++++++------
 hw/s390x/s390-pci-vfio.c         | 42 +++++++++++++++++++++++++++++++++++++
 include/hw/s390x/s390-pci-bus.h  |  9 ++++++++
 include/hw/s390x/s390-pci-inst.h |  3 +++
 include/hw/s390x/s390-pci-vfio.h |  5 +++++
 6 files changed, 109 insertions(+), 11 deletions(-)

diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index a929340..2187173 100644
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
@@ -764,6 +765,7 @@ static void s390_pcihost_realize(DeviceState *dev, Error **errp)
     s->bus_no = 0;
     QTAILQ_INIT(&s->pending_sei);
     QTAILQ_INIT(&s->zpci_devs);
+    QTAILQ_INIT(&s->zpci_dma_limit);
 
     css_register_io_adapters(CSS_IO_ADAPTER_PCI, true, false,
                              S390_ADAPTER_SUPPRESSIBLE, errp);
@@ -941,17 +943,18 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
             }
         }
 
+        pbdev->pdev = pdev;
+        pbdev->iommu = s390_pci_get_iommu(s, pci_get_bus(pdev), pdev->devfn);
+        pbdev->iommu->pbdev = pbdev;
+        pbdev->state = ZPCI_FS_DISABLED;
+
         if (object_dynamic_cast(OBJECT(dev), "vfio-pci")) {
             pbdev->fh |= FH_SHM_VFIO;
+            pbdev->iommu->dma_limit = s390_pci_start_dma_count(s, pbdev);
         } else {
             pbdev->fh |= FH_SHM_EMUL;
         }
 
-        pbdev->pdev = pdev;
-        pbdev->iommu = s390_pci_get_iommu(s, pci_get_bus(pdev), pdev->devfn);
-        pbdev->iommu->pbdev = pbdev;
-        pbdev->state = ZPCI_FS_DISABLED;
-
         if (s390_pci_msix_init(pbdev)) {
             error_setg(errp, "MSI-X support is mandatory "
                        "in the S390 architecture");
@@ -1004,6 +1007,9 @@ static void s390_pcihost_unplug(HotplugHandler *hotplug_dev, DeviceState *dev,
         pbdev->fid = 0;
         QTAILQ_REMOVE(&s->zpci_devs, pbdev, link);
         g_hash_table_remove(s->zpci_table, &pbdev->idx);
+        if (pbdev->iommu->dma_limit) {
+            s390_pci_end_dma_count(s, pbdev->iommu->dma_limit);
+        }
         qdev_unrealize(dev);
     }
 }
diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
index 639b13c..4eadd9e 100644
--- a/hw/s390x/s390-pci-inst.c
+++ b/hw/s390x/s390-pci-inst.c
@@ -32,6 +32,20 @@
         }                                                          \
     } while (0)
 
+static inline void inc_dma_avail(S390PCIIOMMU *iommu)
+{
+    if (iommu->dma_limit) {
+        iommu->dma_limit->avail++;
+    }
+}
+
+static inline void dec_dma_avail(S390PCIIOMMU *iommu)
+{
+    if (iommu->dma_limit) {
+        iommu->dma_limit->avail--;
+    }
+}
+
 static void s390_set_status_code(CPUS390XState *env,
                                  uint8_t r, uint64_t status_code)
 {
@@ -572,7 +586,8 @@ int pcistg_service_call(S390CPU *cpu, uint8_t r1, uint8_t r2, uintptr_t ra)
     return 0;
 }
 
-static void s390_pci_update_iotlb(S390PCIIOMMU *iommu, S390IOTLBEntry *entry)
+static uint32_t s390_pci_update_iotlb(S390PCIIOMMU *iommu,
+                                      S390IOTLBEntry *entry)
 {
     S390IOTLBEntry *cache = g_hash_table_lookup(iommu->iotlb, &entry->iova);
     IOMMUTLBEntry notify = {
@@ -585,14 +600,15 @@ static void s390_pci_update_iotlb(S390PCIIOMMU *iommu, S390IOTLBEntry *entry)
 
     if (entry->perm == IOMMU_NONE) {
         if (!cache) {
-            return;
+            goto out;
         }
         g_hash_table_remove(iommu->iotlb, &entry->iova);
+        inc_dma_avail(iommu);
     } else {
         if (cache) {
             if (cache->perm == entry->perm &&
                 cache->translated_addr == entry->translated_addr) {
-                return;
+                goto out;
             }
 
             notify.perm = IOMMU_NONE;
@@ -606,9 +622,13 @@ static void s390_pci_update_iotlb(S390PCIIOMMU *iommu, S390IOTLBEntry *entry)
         cache->len = PAGE_SIZE;
         cache->perm = entry->perm;
         g_hash_table_replace(iommu->iotlb, &cache->iova, cache);
+        dec_dma_avail(iommu);
     }
 
     memory_region_notify_iommu(&iommu->iommu_mr, 0, notify);
+
+out:
+    return iommu->dma_limit ? iommu->dma_limit->avail : 1;
 }
 
 int rpcit_service_call(S390CPU *cpu, uint8_t r1, uint8_t r2, uintptr_t ra)
@@ -620,6 +640,7 @@ int rpcit_service_call(S390CPU *cpu, uint8_t r1, uint8_t r2, uintptr_t ra)
     S390PCIIOMMU *iommu;
     S390IOTLBEntry entry;
     hwaddr start, end;
+    uint32_t dma_avail;
 
     if (env->psw.mask & PSW_MASK_PSTATE) {
         s390_program_interrupt(env, PGM_PRIVILEGED, ra);
@@ -658,6 +679,11 @@ int rpcit_service_call(S390CPU *cpu, uint8_t r1, uint8_t r2, uintptr_t ra)
     }
 
     iommu = pbdev->iommu;
+    if (iommu->dma_limit) {
+        dma_avail = iommu->dma_limit->avail;
+    } else {
+        dma_avail = 1;
+    }
     if (!iommu->g_iota) {
         error = ERR_EVENT_INVALAS;
         goto err;
@@ -675,8 +701,9 @@ int rpcit_service_call(S390CPU *cpu, uint8_t r1, uint8_t r2, uintptr_t ra)
         }
 
         start += entry.len;
-        while (entry.iova < start && entry.iova < end) {
-            s390_pci_update_iotlb(iommu, &entry);
+        while (entry.iova < start && entry.iova < end &&
+               (dma_avail > 0 || entry.perm == IOMMU_NONE)) {
+            dma_avail = s390_pci_update_iotlb(iommu, &entry);
             entry.iova += PAGE_SIZE;
             entry.translated_addr += PAGE_SIZE;
         }
@@ -689,7 +716,13 @@ err:
         s390_pci_generate_error_event(error, pbdev->fh, pbdev->fid, start, 0);
     } else {
         pbdev->fmb.counter[ZPCI_FMB_CNT_RPCIT]++;
-        setcc(cpu, ZPCI_PCI_LS_OK);
+        if (dma_avail > 0) {
+            setcc(cpu, ZPCI_PCI_LS_OK);
+        } else {
+            /* vfio DMA mappings are exhausted, trigger a RPCIT */
+            setcc(cpu, ZPCI_PCI_LS_ERR);
+            s390_set_status_code(env, r1, ZPCI_RPCIT_ST_INSUFF_RES);
+        }
     }
     return 0;
 }
diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
index cb3f4d9..0621fa3 100644
--- a/hw/s390x/s390-pci-vfio.c
+++ b/hw/s390x/s390-pci-vfio.c
@@ -12,7 +12,9 @@
 #include <sys/ioctl.h>
 
 #include "qemu/osdep.h"
+#include "hw/s390x/s390-pci-bus.h"
 #include "hw/s390x/s390-pci-vfio.h"
+#include "hw/vfio/pci.h"
 #include "hw/vfio/vfio-common.h"
 
 /*
@@ -52,3 +54,43 @@ retry:
     return vfio_get_info_dma_avail(info, avail);
 }
 
+S390PCIDMACount *s390_pci_start_dma_count(S390pciState *s,
+                                          S390PCIBusDevice *pbdev)
+{
+    S390PCIDMACount *cnt;
+    uint32_t avail;
+    VFIOPCIDevice *vpdev = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
+    int id;
+
+    assert(vpdev);
+
+    id = vpdev->vbasedev.group->container->fd;
+
+    if (!s390_pci_update_dma_avail(id, &avail)) {
+        return NULL;
+    }
+
+    QTAILQ_FOREACH(cnt, &s->zpci_dma_limit, link) {
+        if (cnt->id  == id) {
+            cnt->users++;
+            return cnt;
+        }
+    }
+
+    cnt = g_new0(S390PCIDMACount, 1);
+    cnt->id = id;
+    cnt->users = 1;
+    cnt->avail = avail;
+    QTAILQ_INSERT_TAIL(&s->zpci_dma_limit, cnt, link);
+    return cnt;
+}
+
+void s390_pci_end_dma_count(S390pciState *s, S390PCIDMACount *cnt)
+{
+    assert(cnt);
+
+    cnt->users--;
+    if (cnt->users == 0) {
+        QTAILQ_REMOVE(&s->zpci_dma_limit, cnt, link);
+    }
+}
diff --git a/include/hw/s390x/s390-pci-bus.h b/include/hw/s390x/s390-pci-bus.h
index 97464d0..6a35f13 100644
--- a/include/hw/s390x/s390-pci-bus.h
+++ b/include/hw/s390x/s390-pci-bus.h
@@ -262,6 +262,13 @@ typedef struct S390IOTLBEntry {
     uint64_t perm;
 } S390IOTLBEntry;
 
+typedef struct S390PCIDMACount {
+    int id;
+    int users;
+    uint32_t avail;
+    QTAILQ_ENTRY(S390PCIDMACount) link;
+} S390PCIDMACount;
+
 struct S390PCIIOMMU {
     Object parent_obj;
     S390PCIBusDevice *pbdev;
@@ -273,6 +280,7 @@ struct S390PCIIOMMU {
     uint64_t pba;
     uint64_t pal;
     GHashTable *iotlb;
+    S390PCIDMACount *dma_limit;
 };
 
 typedef struct S390PCIIOMMUTable {
@@ -348,6 +356,7 @@ struct S390pciState {
     GHashTable *zpci_table;
     QTAILQ_HEAD(, SeiContainer) pending_sei;
     QTAILQ_HEAD(, S390PCIBusDevice) zpci_devs;
+    QTAILQ_HEAD(, S390PCIDMACount) zpci_dma_limit;
 };
 
 S390pciState *s390_get_phb(void);
diff --git a/include/hw/s390x/s390-pci-inst.h b/include/hw/s390x/s390-pci-inst.h
index fa3bf8b..8ee3a3c 100644
--- a/include/hw/s390x/s390-pci-inst.h
+++ b/include/hw/s390x/s390-pci-inst.h
@@ -254,6 +254,9 @@ typedef struct ClpReqRspQueryPciGrp {
 #define ZPCI_STPCIFC_ST_INVAL_DMAAS   28
 #define ZPCI_STPCIFC_ST_ERROR_RECOVER 40
 
+/* Refresh PCI Translations status codes */
+#define ZPCI_RPCIT_ST_INSUFF_RES      16
+
 /* FIB function controls */
 #define ZPCI_FIB_FC_ENABLED     0x80
 #define ZPCI_FIB_FC_ERROR       0x40
diff --git a/include/hw/s390x/s390-pci-vfio.h b/include/hw/s390x/s390-pci-vfio.h
index 2a5a261..9613783 100644
--- a/include/hw/s390x/s390-pci-vfio.h
+++ b/include/hw/s390x/s390-pci-vfio.h
@@ -12,6 +12,11 @@
 #ifndef HW_S390_PCI_VFIO_H
 #define HW_S390_PCI_VFIO_H
 
+#include "hw/s390x/s390-pci-bus.h"
+
 bool s390_pci_update_dma_avail(int fd, unsigned int *avail);
+S390PCIDMACount *s390_pci_start_dma_count(S390pciState *s,
+                                          S390PCIBusDevice *pbdev);
+void s390_pci_end_dma_count(S390pciState *s, S390PCIDMACount *cnt);
 
 #endif
-- 
1.8.3.1

