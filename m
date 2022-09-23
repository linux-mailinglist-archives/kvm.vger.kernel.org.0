Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73945E76F9
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 11:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbiIWJ12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 05:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbiIWJ1R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 05:27:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B721D12EDBE;
        Fri, 23 Sep 2022 02:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ZCn8/4yU6HVJwMPuffDUtLx+XrAbJbStT+3v4kXCbjg=; b=kJRYYaXwQiFuyotfgUPC/J82U2
        e648pL829ZgrBeu3rt3wCsdE5ncjtmMAayBt1Gxyxy0bkSvaTqi8vfGqWHcwjrG+RkyDH6/QzlKrr
        +2X0spe3klKVjpqRS0bivkhWOlHmza4PihUSJuuqXAJMjua/7QTupR7P9dAMlyCGufDuLcP8UP+5i
        TqNnVhvnzJ4QZDaO8i4Ba6ROcAKuH0YLuUZdHgvy0M+hbqtY32PntvNp34hjCyLtNpcS9ASE+dpWn
        bPTN26AWlxdpE1pCTsyHEbnmZmoSO9okIVg20Gc1EDcbZwnovRyErqmkGFSJTArx9jBOXwsG5Sk88
        qXkOBQdg==;
Received: from ip4d15bec4.dynamic.kabel-deutschland.de ([77.21.190.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1obexa-003JiO-45; Fri, 23 Sep 2022 09:27:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 03/14] vfio/mdev: make mdev.h standalone includable
Date:   Fri, 23 Sep 2022 11:26:41 +0200
Message-Id: <20220923092652.100656-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220923092652.100656-1-hch@lst.de>
References: <20220923092652.100656-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Include <linux/device.h> and <linux/uuid.h> so that users of this headers
don't need to do that and remove those includes that aren't needed
any more.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed By: Kirti Wankhede <kwankhede@nvidia.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c      | 2 --
 drivers/s390/cio/vfio_ccw_drv.c       | 1 -
 drivers/s390/crypto/vfio_ap_private.h | 1 -
 drivers/vfio/mdev/mdev_core.c         | 2 --
 drivers/vfio/mdev/mdev_driver.c       | 1 -
 drivers/vfio/mdev/mdev_sysfs.c        | 2 --
 include/linux/mdev.h                  | 3 +++
 samples/vfio-mdev/mbochs.c            | 1 -
 samples/vfio-mdev/mdpy.c              | 1 -
 samples/vfio-mdev/mtty.c              | 2 --
 10 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index aa329f8bfe420..68f022c4aafbc 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -34,7 +34,6 @@
  */
 
 #include <linux/init.h>
-#include <linux/device.h>
 #include <linux/mm.h>
 #include <linux/kthread.h>
 #include <linux/sched/mm.h>
@@ -43,7 +42,6 @@
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
 #include <linux/eventfd.h>
-#include <linux/uuid.h>
 #include <linux/mdev.h>
 #include <linux/debugfs.h>
 
diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 86d9e428357b0..e9985c63dc6bf 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -12,7 +12,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/mdev.h>
 
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index d782cf463eaba..163eeaaf24cee 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -13,7 +13,6 @@
 #define _VFIO_AP_PRIVATE_H_
 
 #include <linux/types.h>
-#include <linux/device.h>
 #include <linux/mdev.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index b8b9e7911e559..2c32923fbad27 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -8,9 +8,7 @@
  */
 
 #include <linux/module.h>
-#include <linux/device.h>
 #include <linux/slab.h>
-#include <linux/uuid.h>
 #include <linux/sysfs.h>
 #include <linux/mdev.h>
 
diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
index 9c2af59809e2e..7bd4bb9850e81 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -7,7 +7,6 @@
  *             Kirti Wankhede <kwankhede@nvidia.com>
  */
 
-#include <linux/device.h>
 #include <linux/iommu.h>
 #include <linux/mdev.h>
 
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 0ccfeb3dda245..4bfbf49aaa66a 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -9,9 +9,7 @@
 
 #include <linux/sysfs.h>
 #include <linux/ctype.h>
-#include <linux/device.h>
 #include <linux/slab.h>
-#include <linux/uuid.h>
 #include <linux/mdev.h>
 
 #include "mdev_private.h"
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 47ad3b104d9e7..a5d8ae6132a20 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -10,6 +10,9 @@
 #ifndef MDEV_H
 #define MDEV_H
 
+#include <linux/device.h>
+#include <linux/uuid.h>
+
 struct mdev_type;
 
 struct mdev_device {
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 6901947e27d2d..985b6e7136219 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -21,7 +21,6 @@
  */
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index bb2af1ec0f7c6..1daab012b5d89 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -17,7 +17,6 @@
  */
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index d151928e4f21d..86843ce3d9a27 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -12,7 +12,6 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/poll.h>
@@ -20,7 +19,6 @@
 #include <linux/cdev.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
-#include <linux/uuid.h>
 #include <linux/vfio.h>
 #include <linux/iommu.h>
 #include <linux/sysfs.h>
-- 
2.30.2

