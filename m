Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B774D5802CA
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 18:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236268AbiGYQfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 12:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236222AbiGYQfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 12:35:46 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111FC1AF28
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 09:35:45 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31e62bc916aso91411407b3.19
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 09:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Czjfva/xEHnxIRAekEU3ukKmmM4zmZj3A95SVvNiddk=;
        b=spXvFYLf0wMspseexXLV1W/Kjr03rDrWdwHVVW+1zj9hNiIYiPf0F/gU9sMVN4TKq6
         gQs8MrXtetuBI8SquBhEB5ERqA60TF8r0ZUy+wVKLOJpT0UOT2CavNF21Uf0OthfHAVm
         ysC7izsw5fYAhdUxr27zXmn574XN2KTatqIUgPaHCWIK0WW1zY6XmZdg1Zi1aQneAgfw
         wyr9UccIbQ+BB1Gi8NujG1fqeVW+b1q7Cp8PfOJR4KCB/DEW11upb604qPKs7kDQ35wL
         RWs51IVNQmtQtplWKTCupsWHEOC/focJAUtXEfgAewe13spmYWvrzVI/rPuNXMhCoV+v
         zNWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Czjfva/xEHnxIRAekEU3ukKmmM4zmZj3A95SVvNiddk=;
        b=51SQ4+kwGEe/oQfPGCqcERD8+IbN2itxRDAj7rNlRTX8Ta3aLXfNiz7TmGceVWpl3u
         5qO41pZjGLoS0Gww25BLQhh2S+dox7o5gavx2eS+YB5gVABGafwrmV10KDcLmB8+l75N
         cZxU2F47zvL6c6aoEQgMPf9iG9UI5RzlViqfWVN5K25QBqGOVmf2GpXVOPcT6ghrZQKJ
         LwLE1AkRKgwqRClFrqRpbLEKp9QoWCM6Hl1IqNEVT1kMgFrpEwNqd71hds1SecrFnui4
         3jejcw4Zog89Ad7n1SNPdMhTXohzKtttmYrSqfbx/4fkXvtBuIKMBR8mGuFJ9lNmrlxH
         2KeA==
X-Gm-Message-State: AJIora92oK/dogGx7PRfnekjTThfqQ+4wuFw+OCZtaWdB2ZP0Ic60oVp
        3RU8hwsbog8F1BIOVXV/6RnQfxsD64PYvA==
X-Google-Smtp-Source: AGRyM1suAdMdFnRW54/h0EC0TqH46KaqOKkecXbttfBn9j+OGPizB3yN3Spr4dvZwNAemkLG6cUdprfnqbip4A==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:db51:0:b0:31e:878a:3f92 with SMTP id
 d78-20020a0ddb51000000b0031e878a3f92mr10345758ywe.334.1658766944352; Mon, 25
 Jul 2022 09:35:44 -0700 (PDT)
Date:   Mon, 25 Jul 2022 16:35:38 +0000
In-Reply-To: <20220725163539.3145690-1-dmatlack@google.com>
Message-Id: <20220725163539.3145690-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220725163539.3145690-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [RFC PATCH 1/2] KVM: selftests: Rename perf_test_util.[ch] to memstress.[ch]
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename the perf_test_util.[ch] files to memstress.[ch]. Symbols are
renamed in the following commit to reduce the amount of churn here in
hopes of playiing nice with git's file rename detection.

The name "memstress" was chosen to better describe the functionality
proveded by this library, which is to create and run a VM that
reads/writes to guest memory on all vCPUs in parallel.

"memstress" also contains the same number of chracters as "perf_test",
making it a drop-in replacement in symbols, e.g. function names, without
impacting line lengths. Also the lack of underscore between "mem" and
"stress" makes it clear "memstress" is a noun.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/Makefile                      | 4 ++--
 tools/testing/selftests/kvm/access_tracking_perf_test.c   | 2 +-
 tools/testing/selftests/kvm/demand_paging_test.c          | 2 +-
 tools/testing/selftests/kvm/dirty_log_perf_test.c         | 2 +-
 .../kvm/include/{perf_test_util.h => memstress.h}         | 8 ++++----
 .../selftests/kvm/lib/{perf_test_util.c => memstress.c}   | 2 +-
 .../kvm/lib/x86_64/{perf_test_util.c => memstress.c}      | 4 ++--
 .../selftests/kvm/memslot_modification_stress_test.c      | 2 +-
 8 files changed, 13 insertions(+), 13 deletions(-)
 rename tools/testing/selftests/kvm/include/{perf_test_util.h => memstress.h} (89%)
 rename tools/testing/selftests/kvm/lib/{perf_test_util.c => memstress.c} (99%)
 rename tools/testing/selftests/kvm/lib/x86_64/{perf_test_util.c => memstress.c} (97%)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 690b499c3471..754c09e4df62 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -42,14 +42,14 @@ LIBKVM += lib/elf.c
 LIBKVM += lib/guest_modes.c
 LIBKVM += lib/io.c
 LIBKVM += lib/kvm_util.c
-LIBKVM += lib/perf_test_util.c
+LIBKVM += lib/memstress.c
 LIBKVM += lib/rbtree.c
 LIBKVM += lib/sparsebit.c
 LIBKVM += lib/test_util.c
 
 LIBKVM_x86_64 += lib/x86_64/apic.c
 LIBKVM_x86_64 += lib/x86_64/handlers.S
-LIBKVM_x86_64 += lib/x86_64/perf_test_util.c
+LIBKVM_x86_64 += lib/x86_64/memstress.c
 LIBKVM_x86_64 += lib/x86_64/processor.c
 LIBKVM_x86_64 += lib/x86_64/svm.c
 LIBKVM_x86_64 += lib/x86_64/ucall.c
diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 1c2749b1481a..9c9a78ec9134 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -43,7 +43,7 @@
 
 #include "kvm_util.h"
 #include "test_util.h"
-#include "perf_test_util.h"
+#include "memstress.h"
 #include "guest_modes.h"
 
 /* Global variable used to synchronize all of the vCPU threads. */
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 779ae54f89c4..8b53ffeaaa73 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -20,7 +20,7 @@
 
 #include "kvm_util.h"
 #include "test_util.h"
-#include "perf_test_util.h"
+#include "memstress.h"
 #include "guest_modes.h"
 
 #ifdef __NR_userfaultfd
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index f99e39a672d3..769ab87cadcc 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -16,7 +16,7 @@
 
 #include "kvm_util.h"
 #include "test_util.h"
-#include "perf_test_util.h"
+#include "memstress.h"
 #include "guest_modes.h"
 
 #ifdef __aarch64__
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/memstress.h
similarity index 89%
rename from tools/testing/selftests/kvm/include/perf_test_util.h
rename to tools/testing/selftests/kvm/include/memstress.h
index eaa88df0555a..e72dfb43e456 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -1,12 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * tools/testing/selftests/kvm/include/perf_test_util.h
+ * tools/testing/selftests/kvm/include/memstress.h
  *
  * Copyright (C) 2020, Google LLC.
  */
 
-#ifndef SELFTEST_KVM_PERF_TEST_UTIL_H
-#define SELFTEST_KVM_PERF_TEST_UTIL_H
+#ifndef SELFTEST_KVM_MEMSTRESS_H
+#define SELFTEST_KVM_MEMSTRESS_H
 
 #include <pthread.h>
 
@@ -60,4 +60,4 @@ void perf_test_guest_code(uint32_t vcpu_id);
 uint64_t perf_test_nested_pages(int nr_vcpus);
 void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[]);
 
-#endif /* SELFTEST_KVM_PERF_TEST_UTIL_H */
+#endif /* SELFTEST_KVM_MEMSTRESS_H */
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/memstress.c
similarity index 99%
rename from tools/testing/selftests/kvm/lib/perf_test_util.c
rename to tools/testing/selftests/kvm/lib/memstress.c
index 9618b37c66f7..d3aea9e4f6a1 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -5,7 +5,7 @@
 #include <inttypes.h>
 
 #include "kvm_util.h"
-#include "perf_test_util.h"
+#include "memstress.h"
 #include "processor.h"
 
 struct perf_test_args perf_test_args;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c b/tools/testing/selftests/kvm/lib/x86_64/memstress.c
similarity index 97%
rename from tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c
rename to tools/testing/selftests/kvm/lib/x86_64/memstress.c
index 0f344a7c89c4..0bb717ac2cc5 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/memstress.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * x86_64-specific extensions to perf_test_util.c.
+ * x86_64-specific extensions to memstress.c.
  *
  * Copyright (C) 2022, Google, Inc.
  */
@@ -11,7 +11,7 @@
 
 #include "test_util.h"
 #include "kvm_util.h"
-#include "perf_test_util.h"
+#include "memstress.h"
 #include "processor.h"
 #include "vmx.h"
 
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 6ee7e1dde404..edee00eff7c4 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -21,7 +21,7 @@
 #include <linux/bitops.h>
 #include <linux/userfaultfd.h>
 
-#include "perf_test_util.h"
+#include "memstress.h"
 #include "processor.h"
 #include "test_util.h"
 #include "guest_modes.h"

base-commit: 1a4d88a361af4f2e91861d632c6a1fe87a9665c2
prerequisite-patch-id: 8c230105c8a2f1245dedb5b386327d98865d0bb2
prerequisite-patch-id: 9b4329037e2e880db19f3221e47d956b78acadc8
-- 
2.37.1.359.gd136c6c3e2-goog

