Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CE96BBD1
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 13:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfGQLuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 07:50:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45510 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfGQLuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 07:50:03 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF44C309174E;
        Wed, 17 Jul 2019 11:50:02 +0000 (UTC)
Received: from localhost (dhcp-192-232.str.redhat.com [10.33.192.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 72A4B5D720;
        Wed, 17 Jul 2019 11:50:00 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH] vfio: re-arrange vfio region definitions
Date:   Wed, 17 Jul 2019 13:49:56 +0200
Message-Id: <20190717114956.16263-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 17 Jul 2019 11:50:02 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is easy to miss already defined region types. Let's re-arrange
the definitions a bit and add more comments to make it hopefully
a bit clearer.

No functional change.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 include/uapi/linux/vfio.h | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 8f10748dac79..d9bcf40240be 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -295,15 +295,23 @@ struct vfio_region_info_cap_type {
 	__u32 subtype;	/* type specific */
 };
 
+/*
+ * List of region types, global per bus driver.
+ * If you introduce a new type, please add it here.
+ */
+
+/* PCI region type containing a PCI vendor part */
 #define VFIO_REGION_TYPE_PCI_VENDOR_TYPE	(1 << 31)
 #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
+#define VFIO_REGION_TYPE_GFX                    (1)
+#define VFIO_REGION_TYPE_CCW			(2)
 
-/* 8086 Vendor sub-types */
+/* 8086 vendor PCI sub-types */
 #define VFIO_REGION_SUBTYPE_INTEL_IGD_OPREGION	(1)
 #define VFIO_REGION_SUBTYPE_INTEL_IGD_HOST_CFG	(2)
 #define VFIO_REGION_SUBTYPE_INTEL_IGD_LPC_CFG	(3)
 
-#define VFIO_REGION_TYPE_GFX                    (1)
+/* GFX sub-types */
 #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
 
 /**
@@ -353,20 +361,17 @@ struct vfio_region_gfx_edid {
 #define VFIO_DEVICE_GFX_LINK_STATE_DOWN  2
 };
 
-#define VFIO_REGION_TYPE_CCW			(2)
 /* ccw sub-types */
 #define VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD	(1)
 
+/* 10de vendor PCI sub-types */
 /*
- * 10de vendor sub-type
- *
  * NVIDIA GPU NVlink2 RAM is coherent RAM mapped onto the host address space.
  */
 #define VFIO_REGION_SUBTYPE_NVIDIA_NVLINK2_RAM	(1)
 
+/* 1014 vendor PCI sub-types*/
 /*
- * 1014 vendor sub-type
- *
  * IBM NPU NVlink2 ATSD (Address Translation Shootdown) register of NPU
  * to do TLB invalidation on a GPU.
  */
-- 
2.20.1

