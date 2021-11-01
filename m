Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E32144230B
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhKAWLz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:11:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30722 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232027AbhKAWLz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:11:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mNV0USCJ0bTE7YbxR+SPvyYXWmDPBQ41R9sCmOpsXYk=;
        b=HhoX8igNn0xPZeMHOqreAft/VE3RZqj+024RLqEhAMZ4gRMLJxz8oH1kXDseMKnILXVvkq
        o6ckbOvvyjxMJ9YgFE0bvUR8oNpeyRgLux3HE7XvA4H1ilQOALKZeWXB1soPJGOh36gv6m
        qET9fWgKa1iNjgF2JJOzrjda5nYtCiI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-Pg6Uoz8FNPCdslhGX60mEA-1; Mon, 01 Nov 2021 18:09:19 -0400
X-MC-Unique: Pg6Uoz8FNPCdslhGX60mEA-1
Received: by mail-wr1-f70.google.com with SMTP id a2-20020a5d4d42000000b0017b3bcf41b9so4041763wru.23
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mNV0USCJ0bTE7YbxR+SPvyYXWmDPBQ41R9sCmOpsXYk=;
        b=ZQqAt4AKjaaOmes2WGD+I22E3R3XNTuvU2dyMZMqDfKsoahgEjC/Da33KrHZT87quo
         pZMd0T65XHDRRn1P0fsTWaTcWBFn3DtTiq6m//kzLBmoQ2JNt22/Ql6cKmYf3Ls803DH
         gZKrp8uwdJMpBWqIP7xjazBwweoKJDzEEccdq0cIYRKObXdsUbQE6VpKFjDkPc5ce1dX
         suwM+3+uDwT+9fCzwQrLqGCPwGG8GtT/YnCbzOBPUzKAzYJF0dbWZwEs7V2P4w1MGfb0
         0yV0WCjHrgX2i9/tb/3ALBTT2dFQEe/Pj143Hyx/TFflEkaRk1z172ZtRsR8fQweM3UK
         AR0g==
X-Gm-Message-State: AOAM5332g32uwEIicST2pUWLgAtT7TQiQMFcZNL1wqkUBNxDVUicsccz
        XtmJS85OX7gFm6orZzpClcnWKJMqfCcnjzTtndz6DlLtWV/Ym6DRA/z+m7yQB6j0UMY/RPIs0em
        r5uafQry3oARb
X-Received: by 2002:a5d:658c:: with SMTP id q12mr16674207wru.34.1635804558679;
        Mon, 01 Nov 2021 15:09:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7l2Vftm7DMc/eD2Pbw7jBZVxT3bmH28cxDkkzkMDwNXV8YPCcpluT9gBfpkvFnsLHKLEoAQ==
X-Received: by 2002:a5d:658c:: with SMTP id q12mr16674187wru.34.1635804558501;
        Mon, 01 Nov 2021 15:09:18 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id c79sm643941wme.43.2021.11.01.15.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:18 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        xen-devel@lists.xenproject.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?q?Hyman=20Huang=28=C3=A9=C2=BB=E2=80=9E=C3=A5=E2=80=B9?=
         =?UTF-8?q?=E2=80=A1=29?= <huangy81@chinatelecom.cn>
Subject: [PULL 03/20] memory: make global_dirty_tracking a bitmask
Date:   Mon,  1 Nov 2021 23:08:55 +0100
Message-Id: <20211101220912.10039-4-quintela@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101220912.10039-1-quintela@redhat.com>
References: <20211101220912.10039-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hyman Huang(é»„å‹‡) <huangy81@chinatelecom.cn>

since dirty ring has been introduced, there are two methods
to track dirty pages of vm. it seems that "logging" has
a hint on the method, so rename the global_dirty_log to
global_dirty_tracking would make description more accurate.

dirty rate measurement may start or stop dirty tracking during
calculation. this conflict with migration because stop dirty
tracking make migration leave dirty pages out then that'll be
a problem.

make global_dirty_tracking a bitmask can let both migration and
dirty rate measurement work fine. introduce GLOBAL_DIRTY_MIGRATION
and GLOBAL_DIRTY_DIRTY_RATE to distinguish what current dirty
tracking aims for, migration or dirty rate.

Signed-off-by: Hyman Huang(é»„å‹‡) <huangy81@chinatelecom.cn>
Message-Id: <9c9388657cfa0301bd2c1cfa36e7cf6da4aeca19.1624040308.git.huangy81@chinatelecom.cn>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 include/exec/memory.h   | 20 +++++++++++++++++---
 include/exec/ram_addr.h |  4 ++--
 hw/i386/xen/xen-hvm.c   |  4 ++--
 migration/ram.c         | 15 +++++++++++----
 softmmu/memory.c        | 32 +++++++++++++++++++++-----------
 softmmu/trace-events    |  1 +
 6 files changed, 54 insertions(+), 22 deletions(-)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index a185b6dcb8..04280450c9 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -61,7 +61,17 @@ static inline void fuzz_dma_read_cb(size_t addr,
 }
 #endif
 
-extern bool global_dirty_log;
+/* Possible bits for global_dirty_log_{start|stop} */
+
+/* Dirty tracking enabled because migration is running */
+#define GLOBAL_DIRTY_MIGRATION  (1U << 0)
+
+/* Dirty tracking enabled because measuring dirty rate */
+#define GLOBAL_DIRTY_DIRTY_RATE (1U << 1)
+
+#define GLOBAL_DIRTY_MASK  (0x3)
+
+extern unsigned int global_dirty_tracking;
 
 typedef struct MemoryRegionOps MemoryRegionOps;
 
@@ -2388,13 +2398,17 @@ void memory_listener_unregister(MemoryListener *listener);
 
 /**
  * memory_global_dirty_log_start: begin dirty logging for all regions
+ *
+ * @flags: purpose of starting dirty log, migration or dirty rate
  */
-void memory_global_dirty_log_start(void);
+void memory_global_dirty_log_start(unsigned int flags);
 
 /**
  * memory_global_dirty_log_stop: end dirty logging for all regions
+ *
+ * @flags: purpose of stopping dirty log, migration or dirty rate
  */
-void memory_global_dirty_log_stop(void);
+void memory_global_dirty_log_stop(unsigned int flags);
 
 void mtree_info(bool flatview, bool dispatch_tree, bool owner, bool disabled);
 
diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index 551876bed0..45c913264a 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -369,7 +369,7 @@ static inline void cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
 
                     qatomic_or(&blocks[DIRTY_MEMORY_VGA][idx][offset], temp);
 
-                    if (global_dirty_log) {
+                    if (global_dirty_tracking) {
                         qatomic_or(
                                 &blocks[DIRTY_MEMORY_MIGRATION][idx][offset],
                                 temp);
@@ -392,7 +392,7 @@ static inline void cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
     } else {
         uint8_t clients = tcg_enabled() ? DIRTY_CLIENTS_ALL : DIRTY_CLIENTS_NOCODE;
 
-        if (!global_dirty_log) {
+        if (!global_dirty_tracking) {
             clients &= ~(1 << DIRTY_MEMORY_MIGRATION);
         }
 
diff --git a/hw/i386/xen/xen-hvm.c b/hw/i386/xen/xen-hvm.c
index e3d3d5cf89..482be95415 100644
--- a/hw/i386/xen/xen-hvm.c
+++ b/hw/i386/xen/xen-hvm.c
@@ -1613,8 +1613,8 @@ void xen_hvm_modified_memory(ram_addr_t start, ram_addr_t length)
 void qmp_xen_set_global_dirty_log(bool enable, Error **errp)
 {
     if (enable) {
-        memory_global_dirty_log_start();
+        memory_global_dirty_log_start(GLOBAL_DIRTY_MIGRATION);
     } else {
-        memory_global_dirty_log_stop();
+        memory_global_dirty_log_stop(GLOBAL_DIRTY_MIGRATION);
     }
 }
diff --git a/migration/ram.c b/migration/ram.c
index bb908822d5..ae2601bf3b 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -2216,7 +2216,14 @@ static void ram_save_cleanup(void *opaque)
         /* caller have hold iothread lock or is in a bh, so there is
          * no writing race against the migration bitmap
          */
-        memory_global_dirty_log_stop();
+        if (global_dirty_tracking & GLOBAL_DIRTY_MIGRATION) {
+            /*
+             * do not stop dirty log without starting it, since
+             * memory_global_dirty_log_stop will assert that
+             * memory_global_dirty_log_start/stop used in pairs
+             */
+            memory_global_dirty_log_stop(GLOBAL_DIRTY_MIGRATION);
+        }
     }
 
     RAMBLOCK_FOREACH_NOT_IGNORED(block) {
@@ -2678,7 +2685,7 @@ static void ram_init_bitmaps(RAMState *rs)
         ram_list_init_bitmaps();
         /* We don't use dirty log with background snapshots */
         if (!migrate_background_snapshot()) {
-            memory_global_dirty_log_start();
+            memory_global_dirty_log_start(GLOBAL_DIRTY_MIGRATION);
             migration_bitmap_sync_precopy(rs);
         }
     }
@@ -3434,7 +3441,7 @@ void colo_incoming_start_dirty_log(void)
             /* Discard this dirty bitmap record */
             bitmap_zero(block->bmap, block->max_length >> TARGET_PAGE_BITS);
         }
-        memory_global_dirty_log_start();
+        memory_global_dirty_log_start(GLOBAL_DIRTY_MIGRATION);
     }
     ram_state->migration_dirty_pages = 0;
     qemu_mutex_unlock_ramlist();
@@ -3446,7 +3453,7 @@ void colo_release_ram_cache(void)
 {
     RAMBlock *block;
 
-    memory_global_dirty_log_stop();
+    memory_global_dirty_log_stop(GLOBAL_DIRTY_MIGRATION);
     RAMBLOCK_FOREACH_NOT_IGNORED(block) {
         g_free(block->bmap);
         block->bmap = NULL;
diff --git a/softmmu/memory.c b/softmmu/memory.c
index e5826faa0c..f2ac0d2e89 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -39,7 +39,7 @@
 static unsigned memory_region_transaction_depth;
 static bool memory_region_update_pending;
 static bool ioeventfd_update_pending;
-bool global_dirty_log;
+unsigned int global_dirty_tracking;
 
 static QTAILQ_HEAD(, MemoryListener) memory_listeners
     = QTAILQ_HEAD_INITIALIZER(memory_listeners);
@@ -1821,7 +1821,7 @@ uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
     uint8_t mask = mr->dirty_log_mask;
     RAMBlock *rb = mr->ram_block;
 
-    if (global_dirty_log && ((rb && qemu_ram_is_migratable(rb)) ||
+    if (global_dirty_tracking && ((rb && qemu_ram_is_migratable(rb)) ||
                              memory_region_is_iommu(mr))) {
         mask |= (1 << DIRTY_MEMORY_MIGRATION);
     }
@@ -2760,14 +2760,18 @@ void memory_global_after_dirty_log_sync(void)
 
 static VMChangeStateEntry *vmstate_change;
 
-void memory_global_dirty_log_start(void)
+void memory_global_dirty_log_start(unsigned int flags)
 {
     if (vmstate_change) {
         qemu_del_vm_change_state_handler(vmstate_change);
         vmstate_change = NULL;
     }
 
-    global_dirty_log = true;
+    assert(flags && !(flags & (~GLOBAL_DIRTY_MASK)));
+    assert(!(global_dirty_tracking & flags));
+    global_dirty_tracking |= flags;
+
+    trace_global_dirty_changed(global_dirty_tracking);
 
     MEMORY_LISTENER_CALL_GLOBAL(log_global_start, Forward);
 
@@ -2777,9 +2781,13 @@ void memory_global_dirty_log_start(void)
     memory_region_transaction_commit();
 }
 
-static void memory_global_dirty_log_do_stop(void)
+static void memory_global_dirty_log_do_stop(unsigned int flags)
 {
-    global_dirty_log = false;
+    assert(flags && !(flags & (~GLOBAL_DIRTY_MASK)));
+    assert((global_dirty_tracking & flags) == flags);
+    global_dirty_tracking &= ~flags;
+
+    trace_global_dirty_changed(global_dirty_tracking);
 
     /* Refresh DIRTY_MEMORY_MIGRATION bit.  */
     memory_region_transaction_begin();
@@ -2792,8 +2800,9 @@ static void memory_global_dirty_log_do_stop(void)
 static void memory_vm_change_state_handler(void *opaque, bool running,
                                            RunState state)
 {
+    unsigned int flags = (unsigned int)(uintptr_t)opaque;
     if (running) {
-        memory_global_dirty_log_do_stop();
+        memory_global_dirty_log_do_stop(flags);
 
         if (vmstate_change) {
             qemu_del_vm_change_state_handler(vmstate_change);
@@ -2802,18 +2811,19 @@ static void memory_vm_change_state_handler(void *opaque, bool running,
     }
 }
 
-void memory_global_dirty_log_stop(void)
+void memory_global_dirty_log_stop(unsigned int flags)
 {
     if (!runstate_is_running()) {
         if (vmstate_change) {
             return;
         }
         vmstate_change = qemu_add_vm_change_state_handler(
-                                memory_vm_change_state_handler, NULL);
+                                memory_vm_change_state_handler,
+                                (void *)(uintptr_t)flags);
         return;
     }
 
-    memory_global_dirty_log_do_stop();
+    memory_global_dirty_log_do_stop(flags);
 }
 
 static void listener_add_address_space(MemoryListener *listener,
@@ -2825,7 +2835,7 @@ static void listener_add_address_space(MemoryListener *listener,
     if (listener->begin) {
         listener->begin(listener);
     }
-    if (global_dirty_log) {
+    if (global_dirty_tracking) {
         if (listener->log_global_start) {
             listener->log_global_start(listener);
         }
diff --git a/softmmu/trace-events b/softmmu/trace-events
index bf1469990e..9c88887b3c 100644
--- a/softmmu/trace-events
+++ b/softmmu/trace-events
@@ -19,6 +19,7 @@ memory_region_sync_dirty(const char *mr, const char *listener, int global) "mr '
 flatview_new(void *view, void *root) "%p (root %p)"
 flatview_destroy(void *view, void *root) "%p (root %p)"
 flatview_destroy_rcu(void *view, void *root) "%p (root %p)"
+global_dirty_changed(unsigned int bitmask) "bitmask 0x%"PRIx32
 
 # softmmu.c
 vm_stop_flush_all(int ret) "ret %d"
-- 
2.33.1

