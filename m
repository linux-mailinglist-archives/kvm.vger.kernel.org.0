Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660CD5FC994
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 18:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiJLQ5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 12:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiJLQ5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 12:57:40 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A92ADED1F
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:57:39 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id mq15-20020a17090b380f00b0020ad26fa5edso1730935pjb.7
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/+xoUR3UsAPRt8Ng9Zr28F3/1uAqa4Cz9bEhVwbahk=;
        b=KWeTRljU4KmZNwuen8g4YeafTK1eq3vQDtLCjLCiEyv+u+7skBrYPDbWg0mcGJK7sj
         Fwkxnt5+6cVCoIgriUaJRlxClZstkuKPzKf+fZhkL997vRNzQM5WplQkek/Rle5r45F7
         249alnUwnRJAsn2F+0jrMOS0eLX4DvCTeY7i2i/9guZ51uy6gO81VlbO5Zlx8H07Hwqk
         kYWEt67LB48EYFGZ/iWyTUoB5rWQv4qXwGNffjz1h2e6C0WwqV63C0FRXMtPzb3H7TdY
         ebLzF8+nXkeljA6diJzgULimbwzySPEezhwRv56q4oM4o6Voie4Qd/J2pX4TsR2W76a4
         QLxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/+xoUR3UsAPRt8Ng9Zr28F3/1uAqa4Cz9bEhVwbahk=;
        b=TKAz+kFSQPH9+XfUftwxC7xan5Y2Gcx3K4tiYqX8oP7U1biENmcEJ+e99s3idlMvVK
         Zu9o6bxzXC9Si/RhqJhoOaajmz+ziHTIda0uUaDwtXs8xgb/L5hqgXszYfYfOqVBwbfA
         R8P9g2/Dmbf12YRPrBvx+ONNW/y0Y2m+KZ9f1deCbSWxMZX5oESeG+FQFrFNNMAg0130
         kNY8EM53gDathyAE4iF3qAL0NHe01kSC825axpkj4zsCk0l264Rjy09GcKmF0vKRCpZx
         1aq05bfUvOC1IEhH7bfZ31SOagNlYxv7+xvcKTb5Cu+zwwYnUMCa6YhUGCmV/+5LMdtL
         MYTA==
X-Gm-Message-State: ACrzQf3ZEFiGPmpzAK2US43+FZPBjcTxC9sNShPtK2VKYPuDICnOYSZE
        mkJ0OU1lavjz3KWd9dEar7qoWgENajTUmg==
X-Google-Smtp-Source: AMsMyM5EUHchAzZ6CSYl9t//XaRQFgGGcwmuBHhju486aui1lt+YXskwfq5jAC5HKMAXqHRbkCRTYgfC5tjIAw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a63:d54a:0:b0:454:395a:73d6 with SMTP id
 v10-20020a63d54a000000b00454395a73d6mr26707449pgi.531.1665593858655; Wed, 12
 Oct 2022 09:57:38 -0700 (PDT)
Date:   Wed, 12 Oct 2022 09:57:27 -0700
In-Reply-To: <20221012165729.3505266-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221012165729.3505266-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221012165729.3505266-2-dmatlack@google.com>
Subject: [PATCH v2 1/3] KVM: selftests: Rename perf_test_util.[ch] to memstress.[ch]
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
index 0172eb6cb6ee..a00253b79040 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -43,7 +43,7 @@ LIBKVM += lib/elf.c
 LIBKVM += lib/guest_modes.c
 LIBKVM += lib/io.c
 LIBKVM += lib/kvm_util.c
-LIBKVM += lib/perf_test_util.c
+LIBKVM += lib/memstress.c
 LIBKVM += lib/rbtree.c
 LIBKVM += lib/sparsebit.c
 LIBKVM += lib/test_util.c
@@ -52,7 +52,7 @@ LIBKVM_STRING += lib/string_override.c
 
 LIBKVM_x86_64 += lib/x86_64/apic.c
 LIBKVM_x86_64 += lib/x86_64/handlers.S
-LIBKVM_x86_64 += lib/x86_64/perf_test_util.c
+LIBKVM_x86_64 += lib/x86_64/memstress.c
 LIBKVM_x86_64 += lib/x86_64/processor.c
 LIBKVM_x86_64 += lib/x86_64/svm.c
 LIBKVM_x86_64 += lib/x86_64/ucall.c
diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 76c583a07ea2..d953470ce978 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -44,7 +44,7 @@
 
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
2.38.0.rc1.362.ged0d419d3c-goog

