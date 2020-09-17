Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9B826E5C8
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 21:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgIQT4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 15:56:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61802 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727764AbgIQOqC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 10:46:02 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HE5WM1049524;
        Thu, 17 Sep 2020 10:21:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=kspthwTVis4qtTnUOP3Qt5q4hBaR2PUDwTv3DnEx+Lg=;
 b=sBsphagVzSC1BLEoe9H7BI4gGS2IK1t0yLyUO5bSi+AiiwazIZo0wTpLuTUE3J9uWSxx
 Wdi0F8Wk9NtOITlt9WXKPMJZMtpx3/T32s0q87Nybj2id1QZHkcNhfHsYxEyniiyeSYg
 5JSrd1KqE0qoB0L67HmKPmJayGi0DH8kYrDcyTXAFuzROCg3C88vfGMhn2zspgiAR5rE
 XSf+IViXD6PNkx56O4bdRgh6Pu6W8HsCwEPeiP3L0/Wvb3ax0QxObzUDn06naOLv8GBO
 UcseR8Ln8GWEHGH/6pQeUeyKYkgyDHM2GnzFhV3c8Q8MTPgF8voczwPLVDjbWqJGzcmw Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33m92r8vcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 10:21:11 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08HE6Wmd054838;
        Thu, 17 Sep 2020 10:21:11 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33m92r8vbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 10:21:11 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08HEH6Xi010058;
        Thu, 17 Sep 2020 14:21:09 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04dal.us.ibm.com with ESMTP id 33m7u9run7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 14:21:09 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08HEL81f46268818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 14:21:08 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F0B8AC05F;
        Thu, 17 Sep 2020 14:21:08 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04401AC059;
        Thu, 17 Sep 2020 14:21:06 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.85.51])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 17 Sep 2020 14:21:05 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, thuth@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        philmd@redhat.com, qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v4 4/5] s390x/pci: Add routine to get the vfio dma available count
Date:   Thu, 17 Sep 2020 10:20:44 -0400
Message-Id: <1600352445-21110-5-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600352445-21110-1-git-send-email-mjrosato@linux.ibm.com>
References: <1600352445-21110-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_09:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 clxscore=1015 suspectscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009170104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create new files for separating out vfio-specific work for s390
pci. Add the first such routine, which issues VFIO_IOMMU_GET_INFO
ioctl to collect the current dma available count.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/meson.build     |  1 +
 hw/s390x/s390-pci-vfio.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++
 hw/s390x/s390-pci-vfio.h | 17 +++++++++++++++
 3 files changed, 72 insertions(+)
 create mode 100644 hw/s390x/s390-pci-vfio.c
 create mode 100644 hw/s390x/s390-pci-vfio.h

diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
index b63782d..ed2f66b 100644
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
diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
new file mode 100644
index 0000000..f86654d
--- /dev/null
+++ b/hw/s390x/s390-pci-vfio.c
@@ -0,0 +1,54 @@
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
+
+#include "qemu/osdep.h"
+#include "s390-pci-vfio.h"
+#include "hw/vfio/vfio-common.h"
+
+/*
+ * Get the current DMA available count from vfio.  Returns true if vfio is
+ * limiting DMA requests, false otherwise.  The current available count read
+ * from vfio is returned in avail.
+ */
+bool s390_pci_update_dma_avail(int fd, unsigned int *avail)
+{
+    g_autofree struct vfio_iommu_type1_info *info;
+    uint32_t argsz;
+
+    assert(avail);
+
+    argsz = sizeof(struct vfio_iommu_type1_info);
+    info = g_malloc0(argsz);
+
+    /*
+     * If the specified argsz is not large enough to contain all capabilities
+     * it will be updated upon return from the ioctl.  Retry until we have
+     * a big enough buffer to hold the entire capability chain.
+     */
+retry:
+    info->argsz = argsz;
+
+    if (ioctl(fd, VFIO_IOMMU_GET_INFO, info)) {
+        return false;
+    }
+
+    if (info->argsz > argsz) {
+        argsz = info->argsz;
+        info = g_realloc(info, argsz);
+        goto retry;
+    }
+
+    /* If the capability exists, update with the current value */
+    return vfio_get_info_dma_avail(info, avail);
+}
+
diff --git a/hw/s390x/s390-pci-vfio.h b/hw/s390x/s390-pci-vfio.h
new file mode 100644
index 0000000..2a5a261
--- /dev/null
+++ b/hw/s390x/s390-pci-vfio.h
@@ -0,0 +1,17 @@
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
+bool s390_pci_update_dma_avail(int fd, unsigned int *avail);
+
+#endif
-- 
1.8.3.1

