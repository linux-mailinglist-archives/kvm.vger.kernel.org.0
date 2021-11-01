Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1893044230F
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhKAWMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:12:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47345 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232276AbhKAWMA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:12:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4qSeheYxsTSzOnjbgBDH9X0OK6DFyKGFiBbRXcZR8yQ=;
        b=Wa8G9rQHzG+j0Ls5iB0NfThAZ5jw+bCy7t9DeeOUJCiD7jVKmyUNmkL/5uazmqt6BK1eEm
        i6BCKdVUbyUziuV3m1Br1SO29+4sktow15EgLKb4mIvBjvBWtNiYW/2haze0DJp5aOQchU
        A45cwl9DrVDjimNST3eCRtkcGGotiXg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-K3bNN_n-Py6eUtMIPbHOKw-1; Mon, 01 Nov 2021 18:09:25 -0400
X-MC-Unique: K3bNN_n-Py6eUtMIPbHOKw-1
Received: by mail-wr1-f72.google.com with SMTP id c8-20020a056000104800b00186ac81c04fso986211wrx.11
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4qSeheYxsTSzOnjbgBDH9X0OK6DFyKGFiBbRXcZR8yQ=;
        b=Q+Sf8QiNhrdtJhNmpmPjmSpbLdK8cixGcT8TPTofCcHP2lLzUEQPRnya289jKPpHxK
         IVs/Isp5RLCt5VIJEj5XY7ZX2jR0gzfU0lqOn/m4mOBR5/rCgczsmGcckh37ezpTZBC5
         RvfXoD+IIl1BN/hQddHa7FPbFNfxZht3umde/cWUADUxOFzSLaVti/DOHvh9w+WEnV40
         ukGY5B5ah9ca2r3MZTeV+pieH+PF+V3HO79Iw8FtVuLMJpSin8f4EVMcthaxqH9x4uCM
         rp00cNHm4qM9vWw/DuBJalhc33aWiL/F34OuVlYU2aPdQZ8NlW3ZsS3CrjqKy5V78RwN
         d4FA==
X-Gm-Message-State: AOAM531nsdHuMuGDiYLs6SswWhOdl7lVtd11zmhK8aW5xWSB65dswLkz
        ysBIwWdQgAB3h1pbMxpgDMlgxlq5ZQtwR/RYwDdT9Y88AG5xKVagOhKdnalwHPl6lBalS7W/yY7
        2aYEBKejCRPNy
X-Received: by 2002:adf:df89:: with SMTP id z9mr4325032wrl.336.1635804563898;
        Mon, 01 Nov 2021 15:09:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3hGujhhWr5tIpME+wxcFQbUd76XID7qBwn2gPvXB9kRPFZ8nE35rreXch30k76QltMlSD3g==
X-Received: by 2002:adf:df89:: with SMTP id z9mr4325008wrl.336.1635804563683;
        Mon, 01 Nov 2021 15:09:23 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id w17sm9942681wrp.79.2021.11.01.15.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:23 -0700 (PDT)
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
Subject: [PULL 07/20] migration/dirtyrate: implement dirty-ring dirtyrate calculation
Date:   Mon,  1 Nov 2021 23:08:59 +0100
Message-Id: <20211101220912.10039-8-quintela@redhat.com>
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

use dirty ring feature to implement dirtyrate calculation.

introduce mode option in qmp calc_dirty_rate to specify what
method should be used when calculating dirtyrate, either
page-sampling or dirty-ring should be passed.

introduce "dirty_ring:-r" option in hmp calc_dirty_rate to
indicate dirty ring method should be used for calculation.

Signed-off-by: Hyman Huang(é»„å‹‡) <huangy81@chinatelecom.cn>
Message-Id: <7db445109bd18125ce8ec86816d14f6ab5de6a7d.1624040308.git.huangy81@chinatelecom.cn>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 qapi/migration.json    |  16 +++-
 migration/dirtyrate.c  | 208 +++++++++++++++++++++++++++++++++++++++--
 hmp-commands.hx        |   7 +-
 migration/trace-events |   2 +
 4 files changed, 218 insertions(+), 15 deletions(-)

diff --git a/qapi/migration.json b/qapi/migration.json
index 94eece16e1..fae4bc608c 100644
--- a/qapi/migration.json
+++ b/qapi/migration.json
@@ -1796,6 +1796,12 @@
 # @sample-pages: page count per GB for sample dirty pages
 #                the default value is 512 (since 6.1)
 #
+# @mode: mode containing method of calculate dirtyrate includes
+#        'page-sampling' and 'dirty-ring' (Since 6.1)
+#
+# @vcpu-dirty-rate: dirtyrate for each vcpu if dirty-ring
+#                   mode specified (Since 6.1)
+#
 # Since: 5.2
 #
 ##
@@ -1804,7 +1810,9 @@
            'status': 'DirtyRateStatus',
            'start-time': 'int64',
            'calc-time': 'int64',
-           'sample-pages': 'uint64'} }
+           'sample-pages': 'uint64',
+           'mode': 'DirtyRateMeasureMode',
+           '*vcpu-dirty-rate': [ 'DirtyRateVcpu' ] } }
 
 ##
 # @calc-dirty-rate:
@@ -1816,6 +1824,9 @@
 # @sample-pages: page count per GB for sample dirty pages
 #                the default value is 512 (since 6.1)
 #
+# @mode: mechanism of calculating dirtyrate includes
+#        'page-sampling' and 'dirty-ring' (Since 6.1)
+#
 # Since: 5.2
 #
 # Example:
@@ -1824,7 +1835,8 @@
 #
 ##
 { 'command': 'calc-dirty-rate', 'data': {'calc-time': 'int64',
-                                         '*sample-pages': 'int'} }
+                                         '*sample-pages': 'int',
+                                         '*mode': 'DirtyRateMeasureMode'} }
 
 ##
 # @query-dirty-rate:
diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
index b8f61cc650..f92c4b498e 100644
--- a/migration/dirtyrate.c
+++ b/migration/dirtyrate.c
@@ -16,6 +16,7 @@
 #include "cpu.h"
 #include "exec/ramblock.h"
 #include "qemu/rcu_queue.h"
+#include "qemu/main-loop.h"
 #include "qapi/qapi-commands-migration.h"
 #include "ram.h"
 #include "trace.h"
@@ -23,9 +24,19 @@
 #include "monitor/hmp.h"
 #include "monitor/monitor.h"
 #include "qapi/qmp/qdict.h"
+#include "sysemu/kvm.h"
+#include "sysemu/runstate.h"
+#include "exec/memory.h"
+
+typedef struct DirtyPageRecord {
+    uint64_t start_pages;
+    uint64_t end_pages;
+} DirtyPageRecord;
 
 static int CalculatingState = DIRTY_RATE_STATUS_UNSTARTED;
 static struct DirtyRateStat DirtyStat;
+static DirtyRateMeasureMode dirtyrate_mode =
+                DIRTY_RATE_MEASURE_MODE_PAGE_SAMPLING;
 
 static int64_t set_sample_page_period(int64_t msec, int64_t initial_time)
 {
@@ -70,18 +81,37 @@ static int dirtyrate_set_state(int *state, int old_state, int new_state)
 
 static struct DirtyRateInfo *query_dirty_rate_info(void)
 {
+    int i;
     int64_t dirty_rate = DirtyStat.dirty_rate;
     struct DirtyRateInfo *info = g_malloc0(sizeof(DirtyRateInfo));
-
-    if (qatomic_read(&CalculatingState) == DIRTY_RATE_STATUS_MEASURED) {
-        info->has_dirty_rate = true;
-        info->dirty_rate = dirty_rate;
-    }
+    DirtyRateVcpuList *head = NULL, **tail = &head;
 
     info->status = CalculatingState;
     info->start_time = DirtyStat.start_time;
     info->calc_time = DirtyStat.calc_time;
     info->sample_pages = DirtyStat.sample_pages;
+    info->mode = dirtyrate_mode;
+
+    if (qatomic_read(&CalculatingState) == DIRTY_RATE_STATUS_MEASURED) {
+        info->has_dirty_rate = true;
+        info->dirty_rate = dirty_rate;
+
+        if (dirtyrate_mode == DIRTY_RATE_MEASURE_MODE_DIRTY_RING) {
+            /*
+             * set sample_pages with 0 to indicate page sampling
+             * isn't enabled
+             **/
+            info->sample_pages = 0;
+            info->has_vcpu_dirty_rate = true;
+            for (i = 0; i < DirtyStat.dirty_ring.nvcpu; i++) {
+                DirtyRateVcpu *rate = g_malloc0(sizeof(DirtyRateVcpu));
+                rate->id = DirtyStat.dirty_ring.rates[i].id;
+                rate->dirty_rate = DirtyStat.dirty_ring.rates[i].dirty_rate;
+                QAPI_LIST_APPEND(tail, rate);
+            }
+            info->vcpu_dirty_rate = head;
+        }
+    }
 
     trace_query_dirty_rate_info(DirtyRateStatus_str(CalculatingState));
 
@@ -111,6 +141,15 @@ static void init_dirtyrate_stat(int64_t start_time,
     }
 }
 
+static void cleanup_dirtyrate_stat(struct DirtyRateConfig config)
+{
+    /* last calc-dirty-rate qmp use dirty ring mode */
+    if (dirtyrate_mode == DIRTY_RATE_MEASURE_MODE_DIRTY_RING) {
+        free(DirtyStat.dirty_ring.rates);
+        DirtyStat.dirty_ring.rates = NULL;
+    }
+}
+
 static void update_dirtyrate_stat(struct RamblockDirtyInfo *info)
 {
     DirtyStat.page_sampling.total_dirty_samples += info->sample_dirty_count;
@@ -345,7 +384,97 @@ static bool compare_page_hash_info(struct RamblockDirtyInfo *info,
     return true;
 }
 
-static void calculate_dirtyrate(struct DirtyRateConfig config)
+static inline void record_dirtypages(DirtyPageRecord *dirty_pages,
+                                     CPUState *cpu, bool start)
+{
+    if (start) {
+        dirty_pages[cpu->cpu_index].start_pages = cpu->dirty_pages;
+    } else {
+        dirty_pages[cpu->cpu_index].end_pages = cpu->dirty_pages;
+    }
+}
+
+static void dirtyrate_global_dirty_log_start(void)
+{
+    qemu_mutex_lock_iothread();
+    memory_global_dirty_log_start(GLOBAL_DIRTY_DIRTY_RATE);
+    qemu_mutex_unlock_iothread();
+}
+
+static void dirtyrate_global_dirty_log_stop(void)
+{
+    qemu_mutex_lock_iothread();
+    memory_global_dirty_log_sync();
+    memory_global_dirty_log_stop(GLOBAL_DIRTY_DIRTY_RATE);
+    qemu_mutex_unlock_iothread();
+}
+
+static int64_t do_calculate_dirtyrate_vcpu(DirtyPageRecord dirty_pages)
+{
+    uint64_t memory_size_MB;
+    int64_t time_s;
+    uint64_t increased_dirty_pages =
+        dirty_pages.end_pages - dirty_pages.start_pages;
+
+    memory_size_MB = (increased_dirty_pages * TARGET_PAGE_SIZE) >> 20;
+    time_s = DirtyStat.calc_time;
+
+    return memory_size_MB / time_s;
+}
+
+static void calculate_dirtyrate_dirty_ring(struct DirtyRateConfig config)
+{
+    CPUState *cpu;
+    int64_t msec = 0;
+    int64_t start_time;
+    uint64_t dirtyrate = 0;
+    uint64_t dirtyrate_sum = 0;
+    DirtyPageRecord *dirty_pages;
+    int nvcpu = 0;
+    int i = 0;
+
+    CPU_FOREACH(cpu) {
+        nvcpu++;
+    }
+
+    dirty_pages = malloc(sizeof(*dirty_pages) * nvcpu);
+
+    DirtyStat.dirty_ring.nvcpu = nvcpu;
+    DirtyStat.dirty_ring.rates = malloc(sizeof(DirtyRateVcpu) * nvcpu);
+
+    dirtyrate_global_dirty_log_start();
+
+    CPU_FOREACH(cpu) {
+        record_dirtypages(dirty_pages, cpu, true);
+    }
+
+    start_time = qemu_clock_get_ms(QEMU_CLOCK_REALTIME);
+    DirtyStat.start_time = start_time / 1000;
+
+    msec = config.sample_period_seconds * 1000;
+    msec = set_sample_page_period(msec, start_time);
+    DirtyStat.calc_time = msec / 1000;
+
+    dirtyrate_global_dirty_log_stop();
+
+    CPU_FOREACH(cpu) {
+        record_dirtypages(dirty_pages, cpu, false);
+    }
+
+    for (i = 0; i < DirtyStat.dirty_ring.nvcpu; i++) {
+        dirtyrate = do_calculate_dirtyrate_vcpu(dirty_pages[i]);
+        trace_dirtyrate_do_calculate_vcpu(i, dirtyrate);
+
+        DirtyStat.dirty_ring.rates[i].id = i;
+        DirtyStat.dirty_ring.rates[i].dirty_rate = dirtyrate;
+        dirtyrate_sum += dirtyrate;
+    }
+
+    DirtyStat.dirty_rate = dirtyrate_sum;
+    free(dirty_pages);
+}
+
+static void calculate_dirtyrate_sample_vm(struct DirtyRateConfig config)
 {
     struct RamblockDirtyInfo *block_dinfo = NULL;
     int block_count = 0;
@@ -376,6 +505,17 @@ out:
     free_ramblock_dirty_info(block_dinfo, block_count);
 }
 
+static void calculate_dirtyrate(struct DirtyRateConfig config)
+{
+    if (config.mode == DIRTY_RATE_MEASURE_MODE_DIRTY_RING) {
+        calculate_dirtyrate_dirty_ring(config);
+    } else {
+        calculate_dirtyrate_sample_vm(config);
+    }
+
+    trace_dirtyrate_calculate(DirtyStat.dirty_rate);
+}
+
 void *get_dirtyrate_thread(void *arg)
 {
     struct DirtyRateConfig config = *(struct DirtyRateConfig *)arg;
@@ -401,8 +541,12 @@ void *get_dirtyrate_thread(void *arg)
     return NULL;
 }
 
-void qmp_calc_dirty_rate(int64_t calc_time, bool has_sample_pages,
-                         int64_t sample_pages, Error **errp)
+void qmp_calc_dirty_rate(int64_t calc_time,
+                         bool has_sample_pages,
+                         int64_t sample_pages,
+                         bool has_mode,
+                         DirtyRateMeasureMode mode,
+                         Error **errp)
 {
     static struct DirtyRateConfig config;
     QemuThread thread;
@@ -424,6 +568,15 @@ void qmp_calc_dirty_rate(int64_t calc_time, bool has_sample_pages,
         return;
     }
 
+    if (!has_mode) {
+        mode =  DIRTY_RATE_MEASURE_MODE_PAGE_SAMPLING;
+    }
+
+    if (has_sample_pages && mode == DIRTY_RATE_MEASURE_MODE_DIRTY_RING) {
+        error_setg(errp, "either sample-pages or dirty-ring can be specified.");
+        return;
+    }
+
     if (has_sample_pages) {
         if (!is_sample_pages_valid(sample_pages)) {
             error_setg(errp, "sample-pages is out of range[%d, %d].",
@@ -435,6 +588,16 @@ void qmp_calc_dirty_rate(int64_t calc_time, bool has_sample_pages,
         sample_pages = DIRTYRATE_DEFAULT_SAMPLE_PAGES;
     }
 
+    /*
+     * dirty ring mode only works when kvm dirty ring is enabled.
+     */
+    if ((mode == DIRTY_RATE_MEASURE_MODE_DIRTY_RING) &&
+        !kvm_dirty_ring_enabled()) {
+        error_setg(errp, "dirty ring is disabled, use sample-pages method "
+                         "or remeasure later.");
+        return;
+    }
+
     /*
      * Init calculation state as unstarted.
      */
@@ -447,7 +610,15 @@ void qmp_calc_dirty_rate(int64_t calc_time, bool has_sample_pages,
 
     config.sample_period_seconds = calc_time;
     config.sample_pages_per_gigabytes = sample_pages;
-    config.mode = DIRTY_RATE_MEASURE_MODE_PAGE_SAMPLING;
+    config.mode = mode;
+
+    cleanup_dirtyrate_stat(config);
+
+    /*
+     * update dirty rate mode so that we can figure out what mode has
+     * been used in last calculation
+     **/
+    dirtyrate_mode = mode;
 
     start_time = qemu_clock_get_ms(QEMU_CLOCK_REALTIME) / 1000;
     init_dirtyrate_stat(start_time, config);
@@ -473,12 +644,24 @@ void hmp_info_dirty_rate(Monitor *mon, const QDict *qdict)
                    info->sample_pages);
     monitor_printf(mon, "Period: %"PRIi64" (sec)\n",
                    info->calc_time);
+    monitor_printf(mon, "Mode: %s\n",
+                   DirtyRateMeasureMode_str(info->mode));
     monitor_printf(mon, "Dirty rate: ");
     if (info->has_dirty_rate) {
         monitor_printf(mon, "%"PRIi64" (MB/s)\n", info->dirty_rate);
+        if (info->has_vcpu_dirty_rate) {
+            DirtyRateVcpuList *rate, *head = info->vcpu_dirty_rate;
+            for (rate = head; rate != NULL; rate = rate->next) {
+                monitor_printf(mon, "vcpu[%"PRIi64"], Dirty rate: %"PRIi64
+                               " (MB/s)\n", rate->value->id,
+                               rate->value->dirty_rate);
+            }
+        }
     } else {
         monitor_printf(mon, "(not ready)\n");
     }
+
+    qapi_free_DirtyRateVcpuList(info->vcpu_dirty_rate);
     g_free(info);
 }
 
@@ -487,6 +670,10 @@ void hmp_calc_dirty_rate(Monitor *mon, const QDict *qdict)
     int64_t sec = qdict_get_try_int(qdict, "second", 0);
     int64_t sample_pages = qdict_get_try_int(qdict, "sample_pages_per_GB", -1);
     bool has_sample_pages = (sample_pages != -1);
+    bool dirty_ring = qdict_get_try_bool(qdict, "dirty_ring", false);
+    DirtyRateMeasureMode mode =
+        (dirty_ring ? DIRTY_RATE_MEASURE_MODE_DIRTY_RING :
+         DIRTY_RATE_MEASURE_MODE_PAGE_SAMPLING);
     Error *err = NULL;
 
     if (!sec) {
@@ -494,7 +681,8 @@ void hmp_calc_dirty_rate(Monitor *mon, const QDict *qdict)
         return;
     }
 
-    qmp_calc_dirty_rate(sec, has_sample_pages, sample_pages, &err);
+    qmp_calc_dirty_rate(sec, has_sample_pages, sample_pages, true,
+                        mode, &err);
     if (err) {
         hmp_handle_error(mon, err);
         return;
diff --git a/hmp-commands.hx b/hmp-commands.hx
index cf723c69ac..b6d47bd03f 100644
--- a/hmp-commands.hx
+++ b/hmp-commands.hx
@@ -1737,8 +1737,9 @@ ERST
 
     {
         .name       = "calc_dirty_rate",
-        .args_type  = "second:l,sample_pages_per_GB:l?",
-        .params     = "second [sample_pages_per_GB]",
-        .help       = "start a round of guest dirty rate measurement",
+        .args_type  = "dirty_ring:-r,second:l,sample_pages_per_GB:l?",
+        .params     = "[-r] second [sample_pages_per_GB]",
+        .help       = "start a round of guest dirty rate measurement (using -d to"
+                      "\n\t\t\t specify dirty ring as the method of calculation)",
         .cmd        = hmp_calc_dirty_rate,
     },
diff --git a/migration/trace-events b/migration/trace-events
index a8ae163707..b48d873b8a 100644
--- a/migration/trace-events
+++ b/migration/trace-events
@@ -333,6 +333,8 @@ get_ramblock_vfn_hash(const char *idstr, uint64_t vfn, uint32_t crc) "ramblock n
 calc_page_dirty_rate(const char *idstr, uint32_t new_crc, uint32_t old_crc) "ramblock name: %s, new crc: %" PRIu32 ", old crc: %" PRIu32
 skip_sample_ramblock(const char *idstr, uint64_t ramblock_size) "ramblock name: %s, ramblock size: %" PRIu64
 find_page_matched(const char *idstr) "ramblock %s addr or size changed"
+dirtyrate_calculate(int64_t dirtyrate) "dirty rate: %" PRIi64 " MB/s"
+dirtyrate_do_calculate_vcpu(int idx, uint64_t rate) "vcpu[%d]: %"PRIu64 " MB/s"
 
 # block.c
 migration_block_init_shared(const char *blk_device_name) "Start migration for %s with shared base image"
-- 
2.33.1

