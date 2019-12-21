Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A259A128688
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 03:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfLUCE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 21:04:56 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39632 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726680AbfLUCEy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 21:04:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576893893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Gsy1bZQHBxWbwKyjlPkgV/hsiA2M/WXRsoxOsyryh4=;
        b=iWVJNvBi7Ir5y04VjDPQ6uL6IxQya0jjoFZlSj+vV5MWfFuwIB+SLvSgnEAnPcZ8aiMC3B
        dFJUnUUR7BEhhqxN7zmP3bi/qczF48i66GR0TeAQU85NpgwerpPn1AuLAlBges9PGmOoAk
        /8g5DQs3yZU3qtlJ0b0lfPpjphi7f04=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-ef_Da7OTPVG0mWovqP2VNQ-1; Fri, 20 Dec 2019 21:04:52 -0500
X-MC-Unique: ef_Da7OTPVG0mWovqP2VNQ-1
Received: by mail-qv1-f71.google.com with SMTP id v3so1358335qvm.2
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 18:04:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Gsy1bZQHBxWbwKyjlPkgV/hsiA2M/WXRsoxOsyryh4=;
        b=OS5zKzb3URgqtzlXQxW9G6WRK3iPQjVGlo0y7N+1mLTvzIJYg3Xt4zhHVskz1Ht9XF
         HJgzwuyS7MLTLXQHEG0V76rJJPfFmSDFcF2bN6rOwFEjtM1qdSKcqLi2cyOSJbfd7Z6t
         XMfDMtbBECIIqg5vxoUGeLoBWfRY0Cbe268l1Z8//CKWguGzA/w/5UzsSGU4RZcZ7vJZ
         nNH3bxqXH3sHoGxFj3NwWA2qQLuP4qez/p3NX792UY+JH1NQ2jeJFcHwUUT7EXaHvgLm
         SHnBH7CI7ik++NfrFmoK5O/KWCeuswUQLqVSZb63pzRsBd4sC417a2Z5wOC+DANUzTF2
         TdXw==
X-Gm-Message-State: APjAAAVw7/sBf5Vffh9whMGrz4XEF2gHChXnq5tHTZpDfTBuYCkLxPQO
        O+R6saTeqoYpLnEmjl7HiHkkfO2YrdJSLunkyLUwbk9jiVwRymrZZ3hNGznYdUOP0wpVtLX6oaZ
        Tlx6TS6z9X1Am
X-Received: by 2002:a37:4d10:: with SMTP id a16mr16565760qkb.325.1576893891243;
        Fri, 20 Dec 2019 18:04:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqw4rBcJVn1spyjNjaCCpdXEr3su8bqYBzz9tCx0LavLI9GsJIxfmuSAke7nvgEw0aMn94vhaw==
X-Received: by 2002:a37:4d10:: with SMTP id a16mr16565726qkb.325.1576893890869;
        Fri, 20 Dec 2019 18:04:50 -0800 (PST)
Received: from xz-x1.hitronhub.home ([2607:9880:19c0:3f::2])
        by smtp.gmail.com with ESMTPSA id t7sm3400114qkm.136.2019.12.20.18.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 18:04:50 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Dr David Alan Gilbert <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RESEND v2 13/17] KVM: selftests: Use a single binary for dirty/clear log test
Date:   Fri, 20 Dec 2019 21:04:41 -0500
Message-Id: <20191221020445.60476-3-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221014938.58831-1-peterx@redhat.com>
References: <20191221020445.60476-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the clear_dirty_log test, instead merge it into the existing
dirty_log_test.  It should be cleaner to use this single binary to do
both tests, also it's a preparation for the upcoming dirty ring test.

The default test will still be the dirty_log test.  To run the clear
dirty log test, we need to specify "-M clear-log".

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |   2 -
 .../selftests/kvm/clear_dirty_log_test.c      |   2 -
 tools/testing/selftests/kvm/dirty_log_test.c  | 131 +++++++++++++++---
 3 files changed, 110 insertions(+), 25 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c5ec868fa1e5..ad91b7129a93 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -25,11 +25,9 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
-TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 
-TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 
diff --git a/tools/testing/selftests/kvm/clear_dirty_log_test.c b/tools/testing/selftests/kvm/clear_dirty_log_test.c
deleted file mode 100644
index 749336937d37..000000000000
--- a/tools/testing/selftests/kvm/clear_dirty_log_test.c
+++ /dev/null
@@ -1,2 +0,0 @@
-#define USE_CLEAR_DIRTY_LOG
-#include "dirty_log_test.c"
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 3c0ffd34b3b0..a8ae8c0042a8 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -128,6 +128,66 @@ static uint64_t host_dirty_count;
 static uint64_t host_clear_count;
 static uint64_t host_track_next_count;
 
+enum log_mode_t {
+	/* Only use KVM_GET_DIRTY_LOG for logging */
+	LOG_MODE_DIRTY_LOG = 0,
+
+	/* Use both KVM_[GET|CLEAR]_DIRTY_LOG for logging */
+	LOG_MODE_CLERA_LOG = 1,
+
+	LOG_MODE_NUM,
+};
+
+/* Mode of logging.  Default is LOG_MODE_DIRTY_LOG */
+static enum log_mode_t host_log_mode;
+
+static void clear_log_create_vm_done(struct kvm_vm *vm)
+{
+	struct kvm_enable_cap cap = {};
+
+	if (!kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2)) {
+		fprintf(stderr, "KVM_CLEAR_DIRTY_LOG not available, skipping tests\n");
+		exit(KSFT_SKIP);
+	}
+
+	cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
+	cap.args[0] = 1;
+	vm_enable_cap(vm, &cap);
+}
+
+static void dirty_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
+					  void *bitmap, uint32_t num_pages)
+{
+	kvm_vm_get_dirty_log(vm, slot, bitmap);
+}
+
+static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
+					  void *bitmap, uint32_t num_pages)
+{
+	kvm_vm_get_dirty_log(vm, slot, bitmap);
+	kvm_vm_clear_dirty_log(vm, slot, bitmap, 0, num_pages);
+}
+
+struct log_mode {
+	const char *name;
+	/* Hook when the vm creation is done (before vcpu creation) */
+	void (*create_vm_done)(struct kvm_vm *vm);
+	/* Hook to collect the dirty pages into the bitmap provided */
+	void (*collect_dirty_pages) (struct kvm_vm *vm, int slot,
+				     void *bitmap, uint32_t num_pages);
+} log_modes[LOG_MODE_NUM] = {
+	{
+		.name = "dirty-log",
+		.create_vm_done = NULL,
+		.collect_dirty_pages = dirty_log_collect_dirty_pages,
+	},
+	{
+		.name = "clear-log",
+		.create_vm_done = clear_log_create_vm_done,
+		.collect_dirty_pages = clear_log_collect_dirty_pages,
+	},
+};
+
 /*
  * We use this bitmap to track some pages that should have its dirty
  * bit set in the _next_ iteration.  For example, if we detected the
@@ -137,6 +197,33 @@ static uint64_t host_track_next_count;
  */
 static unsigned long *host_bmap_track;
 
+static void log_modes_dump(void)
+{
+	int i;
+
+	for (i = 0; i < LOG_MODE_NUM; i++)
+		printf("%s, ", log_modes[i].name);
+	puts("\b\b  \b\b");
+}
+
+static void log_mode_create_vm_done(struct kvm_vm *vm)
+{
+	struct log_mode *mode = &log_modes[host_log_mode];
+
+	if (mode->create_vm_done)
+		mode->create_vm_done(vm);
+}
+
+static void log_mode_collect_dirty_pages(struct kvm_vm *vm, int slot,
+					 void *bitmap, uint32_t num_pages)
+{
+	struct log_mode *mode = &log_modes[host_log_mode];
+
+	TEST_ASSERT(mode->collect_dirty_pages != NULL,
+		    "collect_dirty_pages() is required for any log mode!");
+	mode->collect_dirty_pages(vm, slot, bitmap, num_pages);
+}
+
 static void generate_random_array(uint64_t *guest_array, uint64_t size)
 {
 	uint64_t i;
@@ -257,6 +344,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 #ifdef __x86_64__
 	vm_create_irqchip(vm);
 #endif
+	log_mode_create_vm_done(vm);
 	vm_vcpu_add_default(vm, vcpuid, guest_code);
 	return vm;
 }
@@ -316,14 +404,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	bmap = bitmap_alloc(host_num_pages);
 	host_bmap_track = bitmap_alloc(host_num_pages);
 
-#ifdef USE_CLEAR_DIRTY_LOG
-	struct kvm_enable_cap cap = {};
-
-	cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
-	cap.args[0] = 1;
-	vm_enable_cap(vm, &cap);
-#endif
-
 	/* Add an extra memory slot for testing dirty logging */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
 				    guest_test_phys_mem,
@@ -364,11 +444,8 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	while (iteration < iterations) {
 		/* Give the vcpu thread some time to dirty some pages */
 		usleep(interval * 1000);
-		kvm_vm_get_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap);
-#ifdef USE_CLEAR_DIRTY_LOG
-		kvm_vm_clear_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap, 0,
-				       host_num_pages);
-#endif
+		log_mode_collect_dirty_pages(vm, TEST_MEM_SLOT_INDEX,
+					     bmap, host_num_pages);
 		vm_dirty_log_verify(bmap);
 		iteration++;
 		sync_global_to_guest(vm, iteration);
@@ -413,6 +490,9 @@ static void help(char *name)
 	       TEST_HOST_LOOP_INTERVAL);
 	printf(" -p: specify guest physical test memory offset\n"
 	       "     Warning: a low offset can conflict with the loaded test code.\n");
+	printf(" -M: specify the host logging mode "
+	       "(default: log-dirty).  Supported modes: \n\t");
+	log_modes_dump();
 	printf(" -m: specify the guest mode ID to test "
 	       "(default: test all supported modes)\n"
 	       "     This option may be used multiple times.\n"
@@ -437,13 +517,6 @@ int main(int argc, char *argv[])
 	unsigned int host_ipa_limit;
 #endif
 
-#ifdef USE_CLEAR_DIRTY_LOG
-	if (!kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2)) {
-		fprintf(stderr, "KVM_CLEAR_DIRTY_LOG not available, skipping tests\n");
-		exit(KSFT_SKIP);
-	}
-#endif
-
 #ifdef __x86_64__
 	vm_guest_mode_params_init(VM_MODE_PXXV48_4K, true, true);
 #endif
@@ -463,7 +536,7 @@ int main(int argc, char *argv[])
 	vm_guest_mode_params_init(VM_MODE_P40V48_4K, true, true);
 #endif
 
-	while ((opt = getopt(argc, argv, "hi:I:p:m:")) != -1) {
+	while ((opt = getopt(argc, argv, "hi:I:p:m:M:")) != -1) {
 		switch (opt) {
 		case 'i':
 			iterations = strtol(optarg, NULL, 10);
@@ -485,6 +558,22 @@ int main(int argc, char *argv[])
 				    "Guest mode ID %d too big", mode);
 			vm_guest_mode_params[mode].enabled = true;
 			break;
+		case 'M':
+			for (i = 0; i < LOG_MODE_NUM; i++) {
+				if (!strcmp(optarg, log_modes[i].name)) {
+					DEBUG("Setting log mode to: '%s'\n",
+					      optarg);
+					host_log_mode = i;
+					break;
+				}
+			}
+			if (i == LOG_MODE_NUM) {
+				printf("Log mode '%s' is invalid.  "
+				       "Please choose from: ", optarg);
+				log_modes_dump();
+				exit(-1);
+			}
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
-- 
2.24.1

