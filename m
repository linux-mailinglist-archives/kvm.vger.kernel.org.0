Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1E72F3D94
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393373AbhALVoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 16:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731073AbhALVn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 16:43:56 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97047C0617B1
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 13:42:59 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id 193so11508pfz.9
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 13:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=9gX0xmw3QVgb6vwQTxeDg6YDYooweR7Ig+LTagfAi6E=;
        b=X9i/NrVrFDmumiNEDo5X2Q0CFTpj8gaW5/lrMr/P1M1/haHq4CZrXUhJ+c7KDTtTUx
         kv1YYJugC02Trvh7WSITIA001Kd6/kRX3j2SeVQz2NWBfwrYBkJkk5pYvS5LXk1fItXG
         bGG//c6sr4c3VYyUUHaT0cTiRfTYTBOh+dOWOSGeSbOQE58YVZLGhonDYiwSl3KpyDhu
         NThAmqv+3gTAgtg/JLu1Yjk8lXb/4CscVR42NfN2P/VV/bHvJS9VdRf8RBbaaNwV0+ld
         Ih78W03wDL1lcu4t55/UPOyaTzliYVOEyJ4G//XXNi+HaeV5N+npTV3him7AP98mE8fh
         I3SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9gX0xmw3QVgb6vwQTxeDg6YDYooweR7Ig+LTagfAi6E=;
        b=k9NpKltv/eu41/3b8GR/uL7qZJbwxYYZQp8s1QFCkbfblaUdIAPyZ1IZ/JeqinTakG
         3enBfku1akT+ChO2si0KrcZCai2QayHf2YKyvngCflkR7OsNhdEikhAqiDSn+CuqUCUw
         ldLjQxcg1+qZd/sslJPFBDkdx1sRmDazR6JJgXl2ko8WfoExnzYyBk0NJY3XaA0K0OK5
         82rByhGwS+4g9vwxv92GDW+BwoXMtuk4RfxyJRB7RMqtca6XZx3nec5B0VgUtH+L0bR0
         aSVM7DRolC6QgmpJw9tcWcpr7xx8pFTls1aRpBExZ2VpDpxAJbBbPe28x4gblixQ5s0F
         mlrw==
X-Gm-Message-State: AOAM532hL7xcoXNG1e5edfOsTuFafismkkRVdCNmIOeIoJjFRPDFscXe
        QNkC+Nj/H0O5LsMzsqiPPAYyvbUIcUFr
X-Google-Smtp-Source: ABdhPJy5NM8pW5xhHvPO3s1Twhqhl2icNpT6ZlCblCChXHHBpGF26Uw5k9GtfdCP8EGVXcYs5u4RbP0Pujti
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a62:7c01:0:b029:19e:1e23:1821 with SMTP id
 x1-20020a627c010000b029019e1e231821mr1131665pfc.72.1610487779107; Tue, 12 Jan
 2021 13:42:59 -0800 (PST)
Date:   Tue, 12 Jan 2021 13:42:48 -0800
In-Reply-To: <20210112214253.463999-1-bgardon@google.com>
Message-Id: <20210112214253.463999-2-bgardon@google.com>
Mime-Version: 1.0
References: <20210112214253.463999-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 1/6] KVM: selftests: Rename timespec_diff_now to timespec_elapsed
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Huth <thuth@redhat.com>, Jacob Xu <jacobhxu@google.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In response to some earlier comments from Peter Xu, rename
timespec_diff_now to the much more sensible timespec_elapsed.

No functional change intended.

Reviewed-by: Jacob Xu <jacobhxu@google.com>
Reviewed-by: Makarand Sonare <makarandsonare@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c  |  8 ++++----
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 14 +++++++-------
 tools/testing/selftests/kvm/include/test_util.h   |  2 +-
 tools/testing/selftests/kvm/lib/test_util.c       |  2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index cdad1eca72f7..a1cd234e6f5e 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -64,7 +64,7 @@ static void *vcpu_worker(void *data)
 			    exit_reason_str(run->exit_reason));
 	}
 
-	ts_diff = timespec_diff_now(start);
+	ts_diff = timespec_elapsed(start);
 	PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_id,
 		       ts_diff.tv_sec, ts_diff.tv_nsec);
 
@@ -95,7 +95,7 @@ static int handle_uffd_page_request(int uffd, uint64_t addr)
 		return r;
 	}
 
-	ts_diff = timespec_diff_now(start);
+	ts_diff = timespec_elapsed(start);
 
 	PER_PAGE_DEBUG("UFFDIO_COPY %d \t%ld ns\n", tid,
 		       timespec_to_ns(ts_diff));
@@ -190,7 +190,7 @@ static void *uffd_handler_thread_fn(void *arg)
 		pages++;
 	}
 
-	ts_diff = timespec_diff_now(start);
+	ts_diff = timespec_elapsed(start);
 	PER_VCPU_DEBUG("userfaulted %ld pages over %ld.%.9lds. (%f/sec)\n",
 		       pages, ts_diff.tv_sec, ts_diff.tv_nsec,
 		       pages / ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
@@ -339,7 +339,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		PER_VCPU_DEBUG("Joined thread for vCPU %d\n", vcpu_id);
 	}
 
-	ts_diff = timespec_diff_now(start);
+	ts_diff = timespec_elapsed(start);
 
 	pr_info("All vCPU threads joined\n");
 
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 2283a0ec74a9..16efe6589b43 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -52,7 +52,7 @@ static void *vcpu_worker(void *data)
 
 		clock_gettime(CLOCK_MONOTONIC, &start);
 		ret = _vcpu_run(vm, vcpu_id);
-		ts_diff = timespec_diff_now(start);
+		ts_diff = timespec_elapsed(start);
 
 		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
 		TEST_ASSERT(get_ucall(vm, vcpu_id, NULL) == UCALL_SYNC,
@@ -149,7 +149,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		pr_debug("Waiting for vcpu_last_completed_iteration == %lu\n",
 			iteration);
 
-	ts_diff = timespec_diff_now(start);
+	ts_diff = timespec_elapsed(start);
 	pr_info("Populate memory time: %ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
@@ -157,7 +157,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	clock_gettime(CLOCK_MONOTONIC, &start);
 	vm_mem_region_set_flags(vm, PERF_TEST_MEM_SLOT_INDEX,
 				KVM_MEM_LOG_DIRTY_PAGES);
-	ts_diff = timespec_diff_now(start);
+	ts_diff = timespec_elapsed(start);
 	pr_info("Enabling dirty logging time: %ld.%.9lds\n\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
@@ -176,7 +176,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 					 vcpu_id, iteration);
 		}
 
-		ts_diff = timespec_diff_now(start);
+		ts_diff = timespec_elapsed(start);
 		vcpu_dirty_total = timespec_add(vcpu_dirty_total, ts_diff);
 		pr_info("Iteration %lu dirty memory time: %ld.%.9lds\n",
 			iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
@@ -184,7 +184,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		clock_gettime(CLOCK_MONOTONIC, &start);
 		kvm_vm_get_dirty_log(vm, PERF_TEST_MEM_SLOT_INDEX, bmap);
 
-		ts_diff = timespec_diff_now(start);
+		ts_diff = timespec_elapsed(start);
 		get_dirty_log_total = timespec_add(get_dirty_log_total,
 						   ts_diff);
 		pr_info("Iteration %lu get dirty log time: %ld.%.9lds\n",
@@ -195,7 +195,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			kvm_vm_clear_dirty_log(vm, PERF_TEST_MEM_SLOT_INDEX, bmap, 0,
 					       host_num_pages);
 
-			ts_diff = timespec_diff_now(start);
+			ts_diff = timespec_elapsed(start);
 			clear_dirty_log_total = timespec_add(clear_dirty_log_total,
 							     ts_diff);
 			pr_info("Iteration %lu clear dirty log time: %ld.%.9lds\n",
@@ -211,7 +211,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* Disable dirty logging */
 	clock_gettime(CLOCK_MONOTONIC, &start);
 	vm_mem_region_set_flags(vm, PERF_TEST_MEM_SLOT_INDEX, 0);
-	ts_diff = timespec_diff_now(start);
+	ts_diff = timespec_elapsed(start);
 	pr_info("Disabling dirty logging time: %ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index ffffa560436b..b86090ef82da 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -64,7 +64,7 @@ int64_t timespec_to_ns(struct timespec ts);
 struct timespec timespec_add_ns(struct timespec ts, int64_t ns);
 struct timespec timespec_add(struct timespec ts1, struct timespec ts2);
 struct timespec timespec_sub(struct timespec ts1, struct timespec ts2);
-struct timespec timespec_diff_now(struct timespec start);
+struct timespec timespec_elapsed(struct timespec start);
 struct timespec timespec_div(struct timespec ts, int divisor);
 
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 8e04c0b1608e..5f87ed32caf5 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -84,7 +84,7 @@ struct timespec timespec_sub(struct timespec ts1, struct timespec ts2)
 	return timespec_add_ns((struct timespec){0}, ns1 - ns2);
 }
 
-struct timespec timespec_diff_now(struct timespec start)
+struct timespec timespec_elapsed(struct timespec start)
 {
 	struct timespec end;
 
-- 
2.30.0.284.gd98b1dd5eaa7-goog

