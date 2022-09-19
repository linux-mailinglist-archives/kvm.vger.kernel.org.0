Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5AB5BD832
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 01:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiISXXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 19:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiISXXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 19:23:07 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E4960DF
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 16:23:06 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b14-20020a056902030e00b006a827d81fd8so570658ybs.17
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 16:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=qO5LBzD7PTj+XZcpdPRv8dlkfXkFuaQ5StsgDBl3BEc=;
        b=He7rw+aj12hyEV+hKz3BbXB7WGAI6JlLpP/8EK8Mw1L6sj8ldrM7Y7G5VQGGkEwyRK
         j1k4xe+RzXYtIwBNscQIqjGVd4WsUe4luLy7rsV6UPotRnqHBN+ud9G0aPt065ZndRj5
         Pat3bnkQ+TPSClvzyRJYGlKCw3MFlLKvrf9YKSJhNgHIML5cLp3aZ4+go1xTWNeGlCiD
         us5Ul/9k2SXm+QobzbKHi0K1GOqO9O+pM/pewU6oPLN8J4NyfvGfjUY73gGCtX8MeKMt
         mFkkmli/Z2hmT6e2epMshbmAuanhKkQvmiFFdOQEcvSGa1mR9vbB8lmIpTbsvr/FTOMB
         d4NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=qO5LBzD7PTj+XZcpdPRv8dlkfXkFuaQ5StsgDBl3BEc=;
        b=kn3O7bH1D2c/Z5BvD1qEh2d/JkOTJaslUzr5+vepOj6bg8tVlzlA8fXZxXwLHcgP7c
         8nlduVYFsuZZrjAH2ct7n+pz7c6bqHdEpm01UrgZ8QgyBtpGbJv2NmpMihUbJAgMrymx
         nBKglBg+5bkZOBAntU8aNO9PY5+vngyKMBqAfDVPREzxqDMpZ3WmqmtX3T9fjIXgAXe+
         iWM/O4L+dNCMyQUIt493I0n6KwzENVphyxPJ4PJnGwxUZN+5MvGQHVc3jTqyDJEo+CRE
         Ozdie+ojTN05foa6mexyXMzFaWVpU8oBw0i3Q+x6iSm/n7hjq6vSuryfIyZRt8tV5bCO
         PEhQ==
X-Gm-Message-State: ACrzQf1cDqBCePXMw993KsbLrL/IaBHyhZ+kYejHziPSy3U2gZtZa82t
        Cp0DA+u7IXqP8TqSNTlAj5AH9vCZc0V9AQ==
X-Google-Smtp-Source: AMsMyM7Bgdgv+CCBp7OEAvrYdwi+9CXYdbDLouKqXBfsun42i17x6dGWuVBYpilH/lW7OiTZJ+nMtKCjuuSk/w==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:dd53:0:b0:349:3510:e316 with SMTP id
 g80-20020a0ddd53000000b003493510e316mr16902185ywe.265.1663629786134; Mon, 19
 Sep 2022 16:23:06 -0700 (PDT)
Date:   Mon, 19 Sep 2022 16:22:59 -0700
In-Reply-To: <20220919232300.1562683-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220919232300.1562683-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220919232300.1562683-2-dmatlack@google.com>
Subject: [PATCH 1/2] KVM: selftests: Rename perf_test_util.[ch] to memstress.[ch]
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Ricardo Koller <ricarkol@google.com>
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
 .../selftests/kvm/memslot_modification_stress_test.c      | 4 ++--
 8 files changed, 14 insertions(+), 14 deletions(-)
 rename tools/testing/selftests/kvm/include/{perf_test_util.h => memstress.h} (89%)
 rename tools/testing/selftests/kvm/lib/{perf_test_util.c => memstress.c} (99%)
 rename tools/testing/selftests/kvm/lib/x86_64/{perf_test_util.c => memstress.c} (97%)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 4c122f1b1737..5dacdcf7f40c 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -43,14 +43,14 @@ LIBKVM += lib/elf.c
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
index 6ee7e1dde404..e1bb2e3573f0 100644
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
@@ -72,7 +72,7 @@ static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
 	int i;
 
 	/*
-	 * Add the dummy memslot just below the perf_test_util memslot, which is
+	 * Add the dummy memslot just below the memstress memslot, which is
 	 * at the top of the guest physical address space.
 	 */
 	gpa = perf_test_args.gpa - pages * vm->page_size;
-- 
2.37.3.968.ga6b4b080e4-goog

