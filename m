Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D9E2867DB
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 20:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgJGS4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 14:56:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62332 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbgJGS4h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 14:56:37 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 097IlCE0111082;
        Wed, 7 Oct 2020 14:56:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=GQyI25/h+gG7Hj1IddulrvoVDZRMjbOYS9ByE7trZeI=;
 b=tss4hw7xJtFkY21HCyYXTKLdm486hFxBkSi420dcO4Sg259ck6q8jb6TAYunn6jHh1S9
 yXvflG7M3Wot0ZQSkiy5Ldy8QoFTjwPYYmId1bIEDpXLJ/HlieKY4Tuw49CkRvenbyfY
 8q2ljVQRquNlYEwusd/QoJog+bKdmu2yc4hbSOOSL108+FUu37JSyvjeQREQ5Da3zQQi
 +NCK6F3hDkn2go2cQHAwQWaVDFlN10h2quIx+tpLs7/cDsPHKHwcrqiEUrcpMO6UlVJJ
 Hlq2aAVoiAsw6IEQqPI2Uw3wG8WI8HQ9DJ6pPoyGTCqgR5Vi4LhizQmiUtEde73KgOlm Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 341k8u05fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 14:56:37 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 097Ilwq5113563;
        Wed, 7 Oct 2020 14:56:36 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 341k8u05f7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 14:56:36 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 097IkeCJ015065;
        Wed, 7 Oct 2020 18:56:35 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma05wdc.us.ibm.com with ESMTP id 33xgx999d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 18:56:35 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 097IuWrH30736774
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Oct 2020 18:56:32 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9120078066;
        Wed,  7 Oct 2020 18:56:32 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D77C7805E;
        Wed,  7 Oct 2020 18:56:31 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.60.106])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  7 Oct 2020 18:56:31 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/5] vfio: Introduce capability definitions for VFIO_DEVICE_GET_INFO
Date:   Wed,  7 Oct 2020 14:56:22 -0400
Message-Id: <1602096984-13703-4-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602096984-13703-1-git-send-email-mjrosato@linux.ibm.com>
References: <1602096984-13703-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0 bulkscore=0
 impostorscore=0 mlxlogscore=838 mlxscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow the VFIO_DEVICE_GET_INFO ioctl to include a capability chain.
Add a flag indicating capability chain support, and introduce the
definitions for the first set of capabilities which are specified to
s390 zPCI devices.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 include/uapi/linux/vfio.h      | 11 ++++++
 include/uapi/linux/vfio_zdev.h | 78 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)
 create mode 100644 include/uapi/linux/vfio_zdev.h

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9204705..836a25b 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -201,8 +201,10 @@ struct vfio_device_info {
 #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
 #define VFIO_DEVICE_FLAGS_CCW	(1 << 4)	/* vfio-ccw device */
 #define VFIO_DEVICE_FLAGS_AP	(1 << 5)	/* vfio-ap device */
+#define VFIO_DEVICE_FLAGS_CAPS	(1 << 6)	/* Info supports caps */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
+	__u32   cap_offset;	/* Offset within info struct of first cap */
 };
 #define VFIO_DEVICE_GET_INFO		_IO(VFIO_TYPE, VFIO_BASE + 7)
 
@@ -218,6 +220,15 @@ struct vfio_device_info {
 #define VFIO_DEVICE_API_CCW_STRING		"vfio-ccw"
 #define VFIO_DEVICE_API_AP_STRING		"vfio-ap"
 
+/*
+ * The following capabilities are unique to s390 zPCI devices.  Their contents
+ * are further-defined in vfio_zdev.h
+ */
+#define VFIO_DEVICE_INFO_CAP_ZPCI_BASE		1
+#define VFIO_DEVICE_INFO_CAP_ZPCI_GROUP		2
+#define VFIO_DEVICE_INFO_CAP_ZPCI_UTIL		3
+#define VFIO_DEVICE_INFO_CAP_ZPCI_PFIP		4
+
 /**
  * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
  *				       struct vfio_region_info)
diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
new file mode 100644
index 0000000..b430939
--- /dev/null
+++ b/include/uapi/linux/vfio_zdev.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * VFIO Region definitions for ZPCI devices
+ *
+ * Copyright IBM Corp. 2020
+ *
+ * Author(s): Pierre Morel <pmorel@linux.ibm.com>
+ *            Matthew Rosato <mjrosato@linux.ibm.com>
+ */
+
+#ifndef _VFIO_ZDEV_H_
+#define _VFIO_ZDEV_H_
+
+#include <linux/types.h>
+#include <linux/vfio.h>
+
+/**
+ * VFIO_DEVICE_INFO_CAP_ZPCI_BASE - Base PCI Function information
+ *
+ * This capability provides a set of descriptive information about the
+ * associated PCI function.
+ */
+struct vfio_device_info_cap_zpci_base {
+	struct vfio_info_cap_header header;
+	__u64 start_dma;	/* Start of available DMA addresses */
+	__u64 end_dma;		/* End of available DMA addresses */
+	__u16 pchid;		/* Physical Channel ID */
+	__u16 vfn;		/* Virtual function number */
+	__u16 fmb_length;	/* Measurement Block Length (in bytes) */
+	__u8 pft;		/* PCI Function Type */
+	__u8 gid;		/* PCI function group ID */
+};
+
+/**
+ * VFIO_DEVICE_INFO_CAP_ZPCI_GROUP - Base PCI Function Group information
+ *
+ * This capability provides a set of descriptive information about the group of
+ * PCI functions that the associated device belongs to.
+ */
+struct vfio_device_info_cap_zpci_group {
+	struct vfio_info_cap_header header;
+	__u64 dasm;		/* DMA Address space mask */
+	__u64 msi_addr;		/* MSI address */
+	__u64 flags;
+#define VFIO_DEVICE_INFO_ZPCI_FLAG_REFRESH 1 /* Program-specified TLB refresh */
+	__u16 mui;		/* Measurement Block Update Interval */
+	__u16 noi;		/* Maximum number of MSIs */
+	__u16 maxstbl;		/* Maximum Store Block Length */
+	__u8 version;		/* Supported PCI Version */
+};
+
+/**
+ * VFIO_DEVICE_INFO_CAP_ZPCI_UTIL - Utility String
+ *
+ * This capability provides the utility string for the associated device, which
+ * is a device identifier string made up of EBCDID characters.  'size' specifies
+ * the length of 'util_str'.
+ */
+struct vfio_device_info_cap_zpci_util {
+	struct vfio_info_cap_header header;
+	__u32 size;
+	__u8 util_str[];
+};
+
+/**
+ * VFIO_DEVICE_INFO_CAP_ZPCI_PFIP - PCI Function Path
+ *
+ * This capability provides the PCI function path string, which is an identifier
+ * that describes the internal hardware path of the device. 'size' specifies
+ * the length of 'pfip'.
+ */
+struct vfio_device_info_cap_zpci_pfip {
+	struct vfio_info_cap_header header;
+	__u32 size;
+	__u8 pfip[];
+};
+
+#endif
-- 
1.8.3.1

