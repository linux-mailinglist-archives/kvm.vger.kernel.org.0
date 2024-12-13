Return-Path: <kvm+bounces-33691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E2DF9F0530
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 08:09:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65A861889937
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 07:09:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 581C618F2EF;
	Fri, 13 Dec 2024 07:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lnyYDw3h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4249E18BBBB
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 07:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734073761; cv=none; b=RSZzXZnoqksuK+e74Qf33RUOemdjzVLLDd0pEajqeQnKFoQfIHRxGuTiwkcYBABskaP5hvaGqdlV8GwjgVjcf+mhEuJ3Z8LMZEIWMJJYkg8HsSoXHRehMRH1oc8OG2A7EBURIN6S9e58XibMHQ5JsHo/onwlN7ye1NDchTZtnTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734073761; c=relaxed/simple;
	bh=+gGDRKc6A8E0xNRDSzs8+ysZ9ibQoXdsqeDZYD2FgLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYkVr9+Q43qIaqA/+CZeZyjYD54RROtMxz/a6oz+ZN7SKjOkfZ+Q0pprU+XvwQyx8Fn3dvGPNr4ygXn1wfQV34NFA2mu+gQCBGLvjc7NJArRiM14x+FOgpXWeRndq8UFBmJkczOMP9WT69iZIK/6IxYh3W0qSjYClU5l2RsKKVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lnyYDw3h; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734073759; x=1765609759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+gGDRKc6A8E0xNRDSzs8+ysZ9ibQoXdsqeDZYD2FgLQ=;
  b=lnyYDw3h/tQP7L9nKubkUeGCBmay6p0D3eoqsLooHvMw4ZOMvMaN/pze
   UtH0xU6TqjeIcfWrdGR2uEoLtTLw0yikDIDVryK1mrjNQm1nYww6eo39t
   InViWP/L8Dxiq+1mGTqhr61uRzTNC/5o/kXMjDc6DPgDaYYokW+uuGEQE
   K0UQ0sHwjj4MKs/rAw+upXO0gNUxO/OXW0JbQES8vbb9lDP9tI2i12Ogt
   JXVBN2rhvXgmT+4Cs2wbSIX1iz89y2AtjCWa5XwBx4wVE7EzUyu65klpO
   hQ+WRlBqs+QP8fhcO8OjNrGwyAxqn0EMsCyJ1l+md6JDTmk+4OfJGcmEF
   g==;
X-CSE-ConnectionGUID: uVRCZRlISuyu40dlpcAvsw==
X-CSE-MsgGUID: T0csoUADQx+jPuZNQyim+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="51937070"
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="51937070"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 23:09:19 -0800
X-CSE-ConnectionGUID: dr84zZlCQqSEHaVcDIz0oQ==
X-CSE-MsgGUID: swkuzg1CTXaftgdaBFhv4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="96365541"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 23:09:16 -0800
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
Subject: [PATCH 1/7] memory: Export a helper to get intersection of a MemoryRegionSection with a given range
Date: Fri, 13 Dec 2024 15:08:43 +0800
Message-ID: <20241213070852.106092-2-chenyi.qiang@intel.com>
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

Rename the helper to memory_region_section_intersect_range() to make it
more generic.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 hw/virtio/virtio-mem.c | 32 +++++---------------------------
 include/exec/memory.h  | 13 +++++++++++++
 system/memory.c        | 17 +++++++++++++++++
 3 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index 80ada89551..e3d1ccaeeb 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -242,28 +242,6 @@ static int virtio_mem_for_each_plugged_range(VirtIOMEM *vmem, void *arg,
     return ret;
 }
 
-/*
- * Adjust the memory section to cover the intersection with the given range.
- *
- * Returns false if the intersection is empty, otherwise returns true.
- */
-static bool virtio_mem_intersect_memory_section(MemoryRegionSection *s,
-                                                uint64_t offset, uint64_t size)
-{
-    uint64_t start = MAX(s->offset_within_region, offset);
-    uint64_t end = MIN(s->offset_within_region + int128_get64(s->size),
-                       offset + size);
-
-    if (end <= start) {
-        return false;
-    }
-
-    s->offset_within_address_space += start - s->offset_within_region;
-    s->offset_within_region = start;
-    s->size = int128_make64(end - start);
-    return true;
-}
-
 typedef int (*virtio_mem_section_cb)(MemoryRegionSection *s, void *arg);
 
 static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
@@ -285,7 +263,7 @@ static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
                                       first_bit + 1) - 1;
         size = (last_bit - first_bit + 1) * vmem->block_size;
 
-        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             break;
         }
         ret = cb(&tmp, arg);
@@ -317,7 +295,7 @@ static int virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
                                  first_bit + 1) - 1;
         size = (last_bit - first_bit + 1) * vmem->block_size;
 
-        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             break;
         }
         ret = cb(&tmp, arg);
@@ -353,7 +331,7 @@ static void virtio_mem_notify_unplug(VirtIOMEM *vmem, uint64_t offset,
     QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
         MemoryRegionSection tmp = *rdl->section;
 
-        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             continue;
         }
         rdl->notify_discard(rdl, &tmp);
@@ -369,7 +347,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
     QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
         MemoryRegionSection tmp = *rdl->section;
 
-        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             continue;
         }
         ret = rdl->notify_populate(rdl, &tmp);
@@ -386,7 +364,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
             if (rdl2 == rdl) {
                 break;
             }
-            if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
+            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
                 continue;
             }
             rdl2->notify_discard(rdl2, &tmp);
diff --git a/include/exec/memory.h b/include/exec/memory.h
index e5e865d1a9..ec7bc641e8 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -1196,6 +1196,19 @@ MemoryRegionSection *memory_region_section_new_copy(MemoryRegionSection *s);
  */
 void memory_region_section_free_copy(MemoryRegionSection *s);
 
+/**
+ * memory_region_section_intersect_range: Adjust the memory section to cover
+ * the intersection with the given range.
+ *
+ * @s: the #MemoryRegionSection to be adjusted
+ * @offset: the offset of the given range in the memory region
+ * @size: the size of the given range
+ *
+ * Returns false if the intersection is empty, otherwise returns true.
+ */
+bool memory_region_section_intersect_range(MemoryRegionSection *s,
+                                           uint64_t offset, uint64_t size);
+
 /**
  * memory_region_init: Initialize a memory region
  *
diff --git a/system/memory.c b/system/memory.c
index 85f6834cb3..ddcec90f5e 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -2898,6 +2898,23 @@ void memory_region_section_free_copy(MemoryRegionSection *s)
     g_free(s);
 }
 
+bool memory_region_section_intersect_range(MemoryRegionSection *s,
+                                           uint64_t offset, uint64_t size)
+{
+    uint64_t start = MAX(s->offset_within_region, offset);
+    uint64_t end = MIN(s->offset_within_region + int128_get64(s->size),
+                       offset + size);
+
+    if (end <= start) {
+        return false;
+    }
+
+    s->offset_within_address_space += start - s->offset_within_region;
+    s->offset_within_region = start;
+    s->size = int128_make64(end - start);
+    return true;
+}
+
 bool memory_region_present(MemoryRegion *container, hwaddr addr)
 {
     MemoryRegion *mr;
-- 
2.43.5


