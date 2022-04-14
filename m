Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C89500B74
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 12:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242475AbiDNKtw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 06:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242455AbiDNKtj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 06:49:39 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A241FA4B
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 03:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649933235; x=1681469235;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MkfDu/adIzxh1OcaPHvWWpqlG9bfb7sCRkpa27MhdSk=;
  b=YgY1Ko3XRmyyib/SUshj7WaIX8VL0QtQyKoAPoXMpK63rSpSa+AGEBO9
   uzySUKXYwrPSfWIhvaVdIwR2A1fB/n0mFGYQ1QsFXp/5btdxVWGxEHpBM
   cgLiokrKIVMz28CzDD/1QmJQW9+Ap5zTHlF17PINfgcbO5YRZOmi8izgY
   BiL1EIASfbOtHh8sJOiWThn0aR+BK+aaMN3sZaxDVWtCb2KtOcGO8fPh5
   ZVQF5cMqIqm8JZcsVd2G/3TUDxrp12dwzND9tJ9jKHWqFvJnM4Ik+sW0r
   IQ3OorHmqocJ47u9glRx98+G3D6/Ae7vQYteLcn6lubI7kDW7Nm2Rdqbs
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="325808668"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="325808668"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 03:47:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="803091193"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 14 Apr 2022 03:47:14 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, eric.auger@redhat.com,
        eric.auger.pro@gmail.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        chao.p.peng@intel.com, yi.y.sun@intel.com, peterx@redhat.com
Subject: [RFC 05/18] vfio/common: Rename VFIOGuestIOMMU::iommu into ::iommu_mr
Date:   Thu, 14 Apr 2022 03:46:57 -0700
Message-Id: <20220414104710.28534-6-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220414104710.28534-1-yi.l.liu@intel.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename VFIOGuestIOMMU iommu field into iommu_mr. Then it becomes clearer
it is an IOMMU memory region.

no functional change intended

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 hw/vfio/common.c              | 16 ++++++++--------
 include/hw/vfio/vfio-common.h |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 080046e3f5..b05f68b5c7 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -992,7 +992,7 @@ static void vfio_listener_region_add(MemoryListener *listener,
          * device emulation the VFIO iommu handles to use).
          */
         giommu = g_malloc0(sizeof(*giommu));
-        giommu->iommu = iommu_mr;
+        giommu->iommu_mr = iommu_mr;
         giommu->iommu_offset = section->offset_within_address_space -
                                section->offset_within_region;
         giommu->container = container;
@@ -1007,7 +1007,7 @@ static void vfio_listener_region_add(MemoryListener *listener,
                             int128_get64(llend),
                             iommu_idx);
 
-        ret = memory_region_iommu_set_page_size_mask(giommu->iommu,
+        ret = memory_region_iommu_set_page_size_mask(giommu->iommu_mr,
                                                      container->pgsizes,
                                                      &err);
         if (ret) {
@@ -1022,7 +1022,7 @@ static void vfio_listener_region_add(MemoryListener *listener,
             goto fail;
         }
         QLIST_INSERT_HEAD(&container->giommu_list, giommu, giommu_next);
-        memory_region_iommu_replay(giommu->iommu, &giommu->n);
+        memory_region_iommu_replay(giommu->iommu_mr, &giommu->n);
 
         return;
     }
@@ -1128,7 +1128,7 @@ static void vfio_listener_region_del(MemoryListener *listener,
         VFIOGuestIOMMU *giommu;
 
         QLIST_FOREACH(giommu, &container->giommu_list, giommu_next) {
-            if (MEMORY_REGION(giommu->iommu) == section->mr &&
+            if (MEMORY_REGION(giommu->iommu_mr) == section->mr &&
                 giommu->n.start == section->offset_within_region) {
                 memory_region_unregister_iommu_notifier(section->mr,
                                                         &giommu->n);
@@ -1393,11 +1393,11 @@ static int vfio_sync_dirty_bitmap(VFIOContainer *container,
         VFIOGuestIOMMU *giommu;
 
         QLIST_FOREACH(giommu, &container->giommu_list, giommu_next) {
-            if (MEMORY_REGION(giommu->iommu) == section->mr &&
+            if (MEMORY_REGION(giommu->iommu_mr) == section->mr &&
                 giommu->n.start == section->offset_within_region) {
                 Int128 llend;
                 vfio_giommu_dirty_notifier gdn = { .giommu = giommu };
-                int idx = memory_region_iommu_attrs_to_index(giommu->iommu,
+                int idx = memory_region_iommu_attrs_to_index(giommu->iommu_mr,
                                                        MEMTXATTRS_UNSPECIFIED);
 
                 llend = int128_add(int128_make64(section->offset_within_region),
@@ -1410,7 +1410,7 @@ static int vfio_sync_dirty_bitmap(VFIOContainer *container,
                                     section->offset_within_region,
                                     int128_get64(llend),
                                     idx);
-                memory_region_iommu_replay(giommu->iommu, &gdn.n);
+                memory_region_iommu_replay(giommu->iommu_mr, &gdn.n);
                 break;
             }
         }
@@ -2246,7 +2246,7 @@ static void vfio_disconnect_container(VFIOGroup *group)
 
         QLIST_FOREACH_SAFE(giommu, &container->giommu_list, giommu_next, tmp) {
             memory_region_unregister_iommu_notifier(
-                    MEMORY_REGION(giommu->iommu), &giommu->n);
+                    MEMORY_REGION(giommu->iommu_mr), &giommu->n);
             QLIST_REMOVE(giommu, giommu_next);
             g_free(giommu);
         }
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index 8af11b0a76..e573f5a9f1 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -98,7 +98,7 @@ typedef struct VFIOContainer {
 
 typedef struct VFIOGuestIOMMU {
     VFIOContainer *container;
-    IOMMUMemoryRegion *iommu;
+    IOMMUMemoryRegion *iommu_mr;
     hwaddr iommu_offset;
     IOMMUNotifier n;
     QLIST_ENTRY(VFIOGuestIOMMU) giommu_next;
-- 
2.27.0

