Return-Path: <kvm+bounces-33695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0FA89F0534
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 08:09:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38638169003
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 07:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4065A18FDB2;
	Fri, 13 Dec 2024 07:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CRzU8fbu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E3918FDC6
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 07:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734073773; cv=none; b=qsoyv7Pgim2jCqLZUD5D9SbkddWilXHHpXUVjZO1Gor/HIf2tZuc5lwPbzEfPZKsTWaEceNqZE9KPxgoOmyYA28HJQR3GgsYDYpSultzTNIIjxNav2TNItZqves9Vw7IU3uln6CoPj9CY+pxhsyjyReiqu7Ka+oCX+f7epsBDyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734073773; c=relaxed/simple;
	bh=A4w+xUWPFzrHzwWGCwJC81L1HqXdufeFhGlIL1EjnJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUL1RV0MgIqBERT2uJ50bTCvSX3biaIxNWk/0kSStPwbsTQ7QuVanatMFvkDGLFz9rky3CRZvmbddqa35FcbfUmFugZSgDg+M0iwaOG5UiLDLuakGupIoQkznJ8yMCkopDAZticO8Xnwj0MUPKGMGYiKVR79efta3OxAM+of3MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CRzU8fbu; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734073772; x=1765609772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A4w+xUWPFzrHzwWGCwJC81L1HqXdufeFhGlIL1EjnJc=;
  b=CRzU8fbuk9T6+s8sfDFIt8m6XxDd13/7hrZ7LHyXufKadp/JUZBU5qTs
   IiBwk0otW+C5muDkuZzF379pSQ8Ya+JKHULO/29W+sdHZMxZsmaceNgS6
   aHa0st3tFhc6w2BSzOwGLdPG0GL/CKtKx5LPoef/svfc6VY3EC1gCjn0k
   qNqQtm0NVeYjJJt8c0yNmz2txkp54sjYbtXskxT4WoeZCurTNvrdBVfjw
   MqaYAFqZW0QtBvFQtuxyN0dun+M69iF/5WwHK4UehIql8vD92bMeAIyuQ
   Ih/LKCacyx1hMmA9NBYDekP1G+BxBQXrvTL9Rnj4xO2ctQ6jfepHKlsdX
   g==;
X-CSE-ConnectionGUID: nyAIUrumSSGpPya6JkXnmA==
X-CSE-MsgGUID: cIvbMKFlRKyUMj07QKFknQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="51937094"
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="51937094"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 23:09:32 -0800
X-CSE-ConnectionGUID: XvVkZrwWTDSpO5tbYZGm3Q==
X-CSE-MsgGUID: WI9Kr5bxSjiT/r1psnF6jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="96365574"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 23:09:29 -0800
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: [PATCH 5/7] memory: Register the RamDiscardManager instance upon guest_memfd creation
Date: Fri, 13 Dec 2024 15:08:47 +0800
Message-ID: <20241213070852.106092-6-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241213070852.106092-1-chenyi.qiang@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce the realize()/unrealize() callbacks to initialize/uninitialize
the new guest_memfd_manager object and register/unregister it in the
target MemoryRegion.

Guest_memfd was initially set to shared until the commit bd3bcf6962
("kvm/memory: Make memory type private by default if it has guest memfd
backend"). To align with this change, the default state in
guest_memfd_manager is set to private. (The bitmap is cleared to 0).
Additionally, setting the default to private can also reduce the
overhead of mapping shared pages into IOMMU by VFIO during the bootup stage.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 include/sysemu/guest-memfd-manager.h | 27 +++++++++++++++++++++++++++
 system/guest-memfd-manager.c         | 28 +++++++++++++++++++++++++++-
 system/physmem.c                     |  7 +++++++
 3 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/guest-memfd-manager.h
index 9dc4e0346d..d1e7f698e8 100644
--- a/include/sysemu/guest-memfd-manager.h
+++ b/include/sysemu/guest-memfd-manager.h
@@ -42,6 +42,8 @@ struct GuestMemfdManager {
 struct GuestMemfdManagerClass {
     ObjectClass parent_class;
 
+    void (*realize)(GuestMemfdManager *gmm, MemoryRegion *mr, uint64_t region_size);
+    void (*unrealize)(GuestMemfdManager *gmm);
     int (*state_change)(GuestMemfdManager *gmm, uint64_t offset, uint64_t size,
                         bool shared_to_private);
 };
@@ -61,4 +63,29 @@ static inline int guest_memfd_manager_state_change(GuestMemfdManager *gmm, uint6
     return 0;
 }
 
+static inline void guest_memfd_manager_realize(GuestMemfdManager *gmm,
+                                              MemoryRegion *mr, uint64_t region_size)
+{
+    GuestMemfdManagerClass *klass;
+
+    g_assert(gmm);
+    klass = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
+
+    if (klass->realize) {
+        klass->realize(gmm, mr, region_size);
+    }
+}
+
+static inline void guest_memfd_manager_unrealize(GuestMemfdManager *gmm)
+{
+    GuestMemfdManagerClass *klass;
+
+    g_assert(gmm);
+    klass = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
+
+    if (klass->unrealize) {
+        klass->unrealize(gmm);
+    }
+}
+
 #endif
diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-manager.c
index 6601df5f3f..b6a32f0bfb 100644
--- a/system/guest-memfd-manager.c
+++ b/system/guest-memfd-manager.c
@@ -366,6 +366,31 @@ static int guest_memfd_state_change(GuestMemfdManager *gmm, uint64_t offset,
     return ret;
 }
 
+static void guest_memfd_manager_realizefn(GuestMemfdManager *gmm, MemoryRegion *mr,
+                                          uint64_t region_size)
+{
+    uint64_t bitmap_size;
+
+    gmm->block_size = qemu_real_host_page_size();
+    bitmap_size = ROUND_UP(region_size, gmm->block_size) / gmm->block_size;
+
+    gmm->mr = mr;
+    gmm->bitmap_size = bitmap_size;
+    gmm->bitmap = bitmap_new(bitmap_size);
+
+    memory_region_set_ram_discard_manager(gmm->mr, RAM_DISCARD_MANAGER(gmm));
+}
+
+static void guest_memfd_manager_unrealizefn(GuestMemfdManager *gmm)
+{
+    memory_region_set_ram_discard_manager(gmm->mr, NULL);
+
+    g_free(gmm->bitmap);
+    gmm->bitmap = NULL;
+    gmm->bitmap_size = 0;
+    gmm->mr = NULL;
+}
+
 static void guest_memfd_manager_init(Object *obj)
 {
     GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
@@ -375,7 +400,6 @@ static void guest_memfd_manager_init(Object *obj)
 
 static void guest_memfd_manager_finalize(Object *obj)
 {
-    g_free(GUEST_MEMFD_MANAGER(obj)->bitmap);
 }
 
 static void guest_memfd_manager_class_init(ObjectClass *oc, void *data)
@@ -384,6 +408,8 @@ static void guest_memfd_manager_class_init(ObjectClass *oc, void *data)
     RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
 
     gmmc->state_change = guest_memfd_state_change;
+    gmmc->realize = guest_memfd_manager_realizefn;
+    gmmc->unrealize = guest_memfd_manager_unrealizefn;
 
     rdmc->get_min_granularity = guest_memfd_rdm_get_min_granularity;
     rdmc->register_listener = guest_memfd_rdm_register_listener;
diff --git a/system/physmem.c b/system/physmem.c
index dc1db3a384..532182a6dd 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -53,6 +53,7 @@
 #include "sysemu/hostmem.h"
 #include "sysemu/hw_accel.h"
 #include "sysemu/xen-mapcache.h"
+#include "sysemu/guest-memfd-manager.h"
 #include "trace.h"
 
 #ifdef CONFIG_FALLOCATE_PUNCH_HOLE
@@ -1885,6 +1886,9 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
             qemu_mutex_unlock_ramlist();
             goto out_free;
         }
+
+        GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(object_new(TYPE_GUEST_MEMFD_MANAGER));
+        guest_memfd_manager_realize(gmm, new_block->mr, new_block->mr->size);
     }
 
     ram_size = (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS;
@@ -2139,6 +2143,9 @@ static void reclaim_ramblock(RAMBlock *block)
 
     if (block->guest_memfd >= 0) {
         close(block->guest_memfd);
+        GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(block->mr->rdm);
+        guest_memfd_manager_unrealize(gmm);
+        object_unref(OBJECT(gmm));
         ram_block_discard_require(false);
     }
 
-- 
2.43.5


