Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0268C37B00B
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 22:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhEKUWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 16:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhEKUWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 16:22:32 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0289AC061574
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 13:21:23 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id s11-20020ac85ecb0000b02901ded4f15245so4859269qtx.22
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 13:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ySDv4Th435kjZfIwnmzgb5838RmbvDKzzPxK4jBsLsU=;
        b=b7gxpOTiK36e4IlyOOUzvOAeiNVmA5WmK1+H6ao/ZTZG8c2WkDWXTelW6cRSbl+8J7
         NVirqQ5ogd3nZ6uao2SRAZWJmReY8THX8WCHk8KPFhYAQ+LaoqDE3guH9scWyZgCxJc7
         YK8xuVFNx3BVilaMk2xWtJMZJ40QsZqrxYdEQeAugDRhfhADOfdF/4zgBkXfocwZIdSP
         Zn7xaAIJ5RRNinW4wLhm+pmhUGDSyVvvnxrwn/sNyCOOY5uoOngMn7jT1KOZSad9Z9bb
         9IhAOMAt1nQFmkr0Rl0H6UWearQti+AtuwkDcwiQ9UuPg9xRiaearNFCG1ZPNayy+W7J
         ygKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ySDv4Th435kjZfIwnmzgb5838RmbvDKzzPxK4jBsLsU=;
        b=YXaiwT74n1tneuUru1X8RsxBtv11KiHaubiFu10Acu8ayL91VEFg6tbWehcefrQPP5
         sfL3oI50vBt+qur8X2bH8RvZoo9ePC7MNrxw0YVuMfyalUbPsjALQG6mkG9OqNOzPnwv
         mCZlL+eyaZx3LxeCVuvoaf60PCn1MfZoxfvkfRlNLKxnnkBr4ahDnE3UqaLw8Y/WmqI6
         5GGth5Kl0IVLZblQuSNo91z4Y9OOQh42xf+UdZC36Jiy9JBuJnB/ok5oRLbkg81zGIFE
         F1WrHfHXNUmZlU3TxBQKkIPp1Da/iIOvxK01Rcjhj4L+fFa1N6+luhOGO8y4McicufTV
         RljA==
X-Gm-Message-State: AOAM531Pbxzb5iHuaz+mtgsoHrFSQmXGjRBq9/NUsFux0p0UlEoFZWty
        FMTfNaYvLUwkodRhnPFQWyE8GO2sq8aVgsOhH+huUdxlA1GC8KthPmLy0U0IPEPZqVZCtyE3tOj
        oALh01TgMqvgyXkExIZv1fHFEXDH+FGIlb7XKRdYTmlmhNtyddpqJVwCJPkEdyDI=
X-Google-Smtp-Source: ABdhPJyvvvIenxzYMnKY4dpiQUWUd3D0rp+S8jZs1BeppjQ+zOgXJqyaFomIJEa14r57YQZUynMj3LBNAt5PRw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a0c:f603:: with SMTP id
 r3mr31194684qvm.59.1620764483054; Tue, 11 May 2021 13:21:23 -0700 (PDT)
Date:   Tue, 11 May 2021 20:21:20 +0000
Message-Id: <20210511202120.1371800-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v4] KVM: selftests: Print a message if /dev/kvm is missing
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a KVM selftest is run on a machine without /dev/kvm, it will exit
silently. Make it easy to tell what's happening by printing an error
message.

Opportunistically consolidate all codepaths that open /dev/kvm into a
single function so they all print the same message.

This slightly changes the semantics of vm_is_unrestricted_guest() by
changing a TEST_ASSERT() to exit(KSFT_SKIP). However
vm_is_unrestricted_guest() is only called in one place
(x86_64/mmio_warning_test.c) and that is to determine if the test should
be skipped or not.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 45 +++++++++++++------
 .../selftests/kvm/lib/x86_64/processor.c      | 16 ++-----
 .../kvm/x86_64/get_msr_index_features.c       |  8 +---
 4 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a8f022794ce3..84982eb02b29 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -77,6 +77,7 @@ struct vm_guest_mode_params {
 };
 extern const struct vm_guest_mode_params vm_guest_mode_params[];
 
+int open_kvm_dev_path_or_exit(void);
 int kvm_check_cap(long cap);
 int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
 int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index fc83f6c5902d..1af1009254c4 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -31,6 +31,33 @@ static void *align(void *x, size_t size)
 	return (void *) (((size_t) x + mask) & ~mask);
 }
 
+/*
+ * Open KVM_DEV_PATH if available, otherwise exit the entire program.
+ *
+ * Input Args:
+ *   flags - The flags to pass when opening KVM_DEV_PATH.
+ *
+ * Return:
+ *   The opened file descriptor of /dev/kvm.
+ */
+static int _open_kvm_dev_path_or_exit(int flags)
+{
+	int fd;
+
+	fd = open(KVM_DEV_PATH, flags);
+	if (fd < 0) {
+		print_skip("%s not available", KVM_DEV_PATH);
+		exit(KSFT_SKIP);
+	}
+
+	return fd;
+}
+
+int open_kvm_dev_path_or_exit(void)
+{
+	return _open_kvm_dev_path_or_exit(O_RDONLY);
+}
+
 /*
  * Capability
  *
@@ -52,10 +79,7 @@ int kvm_check_cap(long cap)
 	int ret;
 	int kvm_fd;
 
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
-
+	kvm_fd = open_kvm_dev_path_or_exit();
 	ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
 	TEST_ASSERT(ret != -1, "KVM_CHECK_EXTENSION IOCTL failed,\n"
 		"  rc: %i errno: %i", ret, errno);
@@ -128,9 +152,7 @@ void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
 
 static void vm_open(struct kvm_vm *vm, int perm)
 {
-	vm->kvm_fd = open(KVM_DEV_PATH, perm);
-	if (vm->kvm_fd < 0)
-		exit(KSFT_SKIP);
+	vm->kvm_fd = _open_kvm_dev_path_or_exit(perm);
 
 	if (!kvm_check_cap(KVM_CAP_IMMEDIATE_EXIT)) {
 		print_skip("immediate_exit not available");
@@ -925,9 +947,7 @@ static int vcpu_mmap_sz(void)
 {
 	int dev_fd, ret;
 
-	dev_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (dev_fd < 0)
-		exit(KSFT_SKIP);
+	dev_fd = open_kvm_dev_path_or_exit();
 
 	ret = ioctl(dev_fd, KVM_GET_VCPU_MMAP_SIZE, NULL);
 	TEST_ASSERT(ret >= sizeof(struct kvm_run),
@@ -2015,10 +2035,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm)
 
 	if (vm == NULL) {
 		/* Ensure that the KVM vendor-specific module is loaded. */
-		f = fopen(KVM_DEV_PATH, "r");
-		TEST_ASSERT(f != NULL, "Error in opening KVM dev file: %d",
-			    errno);
-		fclose(f);
+		close(open_kvm_dev_path_or_exit());
 	}
 
 	f = fopen("/sys/module/kvm_intel/parameters/unrestricted_guest", "r");
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index a8906e60a108..efe235044421 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -657,9 +657,7 @@ struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 		return cpuid;
 
 	cpuid = allocate_kvm_cpuid2();
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit();
 
 	ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_CPUID, cpuid);
 	TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_CPUID failed %d %d\n",
@@ -691,9 +689,7 @@ uint64_t kvm_get_feature_msr(uint64_t msr_index)
 
 	buffer.header.nmsrs = 1;
 	buffer.entry.index = msr_index;
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit();
 
 	r = ioctl(kvm_fd, KVM_GET_MSRS, &buffer.header);
 	TEST_ASSERT(r == 1, "KVM_GET_MSRS IOCTL failed,\n"
@@ -986,9 +982,7 @@ struct kvm_msr_list *kvm_get_msr_index_list(void)
 	struct kvm_msr_list *list;
 	int nmsrs, r, kvm_fd;
 
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit();
 
 	nmsrs = kvm_get_num_msrs_fd(kvm_fd);
 	list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
@@ -1312,9 +1306,7 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
 		return cpuid;
 
 	cpuid = allocate_kvm_cpuid2();
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit();
 
 	ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
 	TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_HV_CPUID failed %d %d\n",
diff --git a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
index cb953df4d7d0..8aed0db1331d 100644
--- a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
+++ b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
@@ -37,9 +37,7 @@ static void test_get_msr_index(void)
 	int old_res, res, kvm_fd, r;
 	struct kvm_msr_list *list;
 
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit();
 
 	old_res = kvm_num_index_msrs(kvm_fd, 0);
 	TEST_ASSERT(old_res != 0, "Expecting nmsrs to be > 0");
@@ -101,9 +99,7 @@ static void test_get_msr_feature(void)
 	int res, old_res, i, kvm_fd;
 	struct kvm_msr_list *feature_list;
 
-	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
-		exit(KSFT_SKIP);
+	kvm_fd = open_kvm_dev_path_or_exit();
 
 	old_res = kvm_num_feature_msrs(kvm_fd, 0);
 	TEST_ASSERT(old_res != 0, "Expecting nmsrs to be > 0");
-- 
2.31.1.607.g51e8a6a459-goog

