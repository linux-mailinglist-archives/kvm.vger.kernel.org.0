Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08DBE79F91C
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbjINDwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbjINDwb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:52:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447C099
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 20:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694663547; x=1726199547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K9SNVbRXg6fOO0WdYvXxGQ1S9s3Q8v1uTfTUmIhxgis=;
  b=jmnXA4xRKx/p83MppkTHiDG8EA7apQg8xv3bxUUtAhd3mlia0RmBQGUQ
   kcq53+wNY4eZuM6MBfYesDFe5vwdNoOxF32AbXEkNGci0VSHoFyThiquj
   RXhba5urvkC59oK1w7S3W/qoBsMb8FWYQEJl9qTpDdWv0HjunYRBWQ1c2
   GKeOh3k4tI1OKnXNmXNSUKgsoujl6wl7FuWSwpLQT82nonWUZUItgIwDM
   tu9uZYvQ0xV7AAbhSSAiK34uBDiyKkMLq3l7OPjhveCSKJ9jKBT0zW+j/
   95+n+ngDx8wRQaM5DZit0zweIYGarnUPEC0wsjBxiK1iwinlEsOjKtFsH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="381528490"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="381528490"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 20:52:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814500650"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="814500650"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmsmga004.fm.intel.com with ESMTP; 13 Sep 2023 20:52:22 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
Subject: [RFC PATCH v2 14/21] physmem: replace function name with __func__ in ram_block_discard_range()
Date:   Wed, 13 Sep 2023 23:51:10 -0400
Message-Id: <20230914035117.3285885-15-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914035117.3285885-1-xiaoyao.li@intel.com>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 softmmu/physmem.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index 2d98a88f41f0..34d580ec0d39 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -3440,16 +3440,15 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
     uint8_t *host_startaddr = rb->host + start;
 
     if (!QEMU_PTR_IS_ALIGNED(host_startaddr, rb->page_size)) {
-        error_report("ram_block_discard_range: Unaligned start address: %p",
-                     host_startaddr);
+        error_report("%s: Unaligned start address: %p",
+                     __func__, host_startaddr);
         goto err;
     }
 
     if ((start + length) <= rb->max_length) {
         bool need_madvise, need_fallocate;
         if (!QEMU_IS_ALIGNED(length, rb->page_size)) {
-            error_report("ram_block_discard_range: Unaligned length: %zx",
-                         length);
+            error_report("%s: Unaligned length: %zx", __func__, length);
             goto err;
         }
 
@@ -3479,27 +3478,26 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
              * file.
              */
             if (!qemu_ram_is_shared(rb)) {
-                warn_report_once("ram_block_discard_range: Discarding RAM"
+                warn_report_once("%s: Discarding RAM"
                                  " in private file mappings is possibly"
                                  " dangerous, because it will modify the"
                                  " underlying file and will affect other"
-                                 " users of the file");
+                                 " users of the file", __func__);
             }
 
             ret = fallocate(rb->fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
                             start, length);
             if (ret) {
                 ret = -errno;
-                error_report("ram_block_discard_range: Failed to fallocate "
-                             "%s:%" PRIx64 " +%zx (%d)",
-                             rb->idstr, start, length, ret);
+                error_report("%s: Failed to fallocate %s:%" PRIx64 " +%zx (%d)",
+                             __func__, rb->idstr, start, length, ret);
                 goto err;
             }
 #else
             ret = -ENOSYS;
-            error_report("ram_block_discard_range: fallocate not available/file"
+            error_report("%s: fallocate not available/file"
                          "%s:%" PRIx64 " +%zx (%d)",
-                         rb->idstr, start, length, ret);
+                         __func__, rb->idstr, start, length, ret);
             goto err;
 #endif
         }
@@ -3517,25 +3515,23 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
             }
             if (ret) {
                 ret = -errno;
-                error_report("ram_block_discard_range: Failed to discard range "
+                error_report("%s: Failed to discard range "
                              "%s:%" PRIx64 " +%zx (%d)",
-                             rb->idstr, start, length, ret);
+                             __func__, rb->idstr, start, length, ret);
                 goto err;
             }
 #else
             ret = -ENOSYS;
-            error_report("ram_block_discard_range: MADVISE not available"
-                         "%s:%" PRIx64 " +%zx (%d)",
-                         rb->idstr, start, length, ret);
+            error_report("%s: MADVISE not available %s:%" PRIx64 " +%zx (%d)",
+                         __func__, rb->idstr, start, length, ret);
             goto err;
 #endif
         }
         trace_ram_block_discard_range(rb->idstr, host_startaddr, length,
                                       need_madvise, need_fallocate, ret);
     } else {
-        error_report("ram_block_discard_range: Overrun block '%s' (%" PRIu64
-                     "/%zx/" RAM_ADDR_FMT")",
-                     rb->idstr, start, length, rb->max_length);
+        error_report("%s: Overrun block '%s' (%" PRIu64 "/%zx/" RAM_ADDR_FMT")",
+                     __func__, rb->idstr, start, length, rb->max_length);
     }
 
 err:
-- 
2.34.1

