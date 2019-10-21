Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC75DF8B5
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 01:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbfJUXeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 19:34:06 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:37208 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730299AbfJUXeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 19:34:05 -0400
Received: by mail-pg1-f201.google.com with SMTP id u20so7480130pga.4
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 16:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5hHgpODb5mQLC7Xd4EXBMoWdq6Sui+2g/Q5ybeTX4iU=;
        b=HKo7f210cXlEwvo3PrDh/I9xY0gVb1Xv94366YI7oRzytJL/3JiIX7KW82j097ZuUt
         YNe12O6Oh1aL/6G7zEdXlSqb6RBeQ9tW++DnQRdgeE04Hgs4gLzGifYhDbtyfrpcQVGt
         w9scSQdAhhThDmzPIeM/16TT3RiM8/pLC11fu2wznqsdHeHqR4FJrkHMjUGMnh1Sw121
         +Lmsf0w91PJ4RdBrtLS686PbXKEqsun/A3XQZeka7F09rBTf2ZTh98QPCviFnIxIx4KR
         LCz1rTUtWYaXZ89Cp/WNBAEf0WYnVRsyzR8qGq3zxGVrUyOXST7rQQpNRTOM602SbOI7
         2CaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5hHgpODb5mQLC7Xd4EXBMoWdq6Sui+2g/Q5ybeTX4iU=;
        b=Nc3gpNzqKrzBKXSiWuNhg9942ivlEm/NcjwpZIE+s1Co2upeyyf6mqiR1cILzmuXV8
         gd0+6NX1JiNAnk4atyXTsOKuupbaWVH8mPQo2QuJ4++MRJJ/R90HaFiX4RlTL9uMz+IP
         d254RKAKJusNHUi4ExqXVVxER8cyPLkAvImxQjaDoeBy8+0bGjmWbTPk0GAVbPeAAE8w
         ogY31nZooaNvvn/hrW9p09H4FG0Wdus/RGFwgNmDYK4nT1zv45ja47lmniIflfoyHArx
         MpD4dbvOKQwNbBAA5fN4VgVsU1GQ8DZFebbukHj50w/kSEDF2w77e5meSXPnmuimNJyq
         3Ajg==
X-Gm-Message-State: APjAAAVyY9tZ4aCKaGcx59MH2PnbFfTG7BWZrYQ02t4HiUl5Zh0m9gtf
        gQ7M98XmDP0wVychv4eapFjpMqQ8raj5yU/G
X-Google-Smtp-Source: APXvYqyp/QiaxSt2/cruWq42e4bbj180sfNZRHJYZqjdEp2uXzzvXsd8esUhWqoxCBZ8o+oY12vl8Pm6ePzTv3a4
X-Received: by 2002:a63:2326:: with SMTP id j38mr411803pgj.283.1571700843302;
 Mon, 21 Oct 2019 16:34:03 -0700 (PDT)
Date:   Mon, 21 Oct 2019 16:30:28 -0700
In-Reply-To: <20191021233027.21566-1-aaronlewis@google.com>
Message-Id: <20191021233027.21566-10-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191021233027.21566-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v3 9/9] kvm: tests: Add test to verify MSR_IA32_XSS
From:   Aaron Lewis <aaronlewis@google.com>
To:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ensure that IA32_XSS appears in KVM_GET_MSR_INDEX_LIST if it can be set
to a non-zero value.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Change-Id: Ia2d644f69e2d6d8c27d7e0a7a45c2bf9c42bf5ff
---
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/include/x86_64/processor.h  |  7 +-
 .../selftests/kvm/lib/x86_64/processor.c      | 72 +++++++++++++++---
 .../selftests/kvm/x86_64/xss_msr_test.c       | 76 +++++++++++++++++++
 5 files changed, 147 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/xss_msr_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index b35da375530a..6e9ec34f8124 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -11,6 +11,7 @@
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_set_nested_state_test
 /x86_64/vmx_tsc_adjust_test
+/x86_64/xss_msr_test
 /clear_dirty_log_test
 /dirty_log_test
 /kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c5ec868fa1e5..3138a916574a 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -25,6 +25,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
+TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
 TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index ff234018219c..635ee6c33ad2 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -308,6 +308,8 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid,
 		     struct kvm_x86_state *state);
 
+struct kvm_msr_list *kvm_get_msr_index_list(void);
+
 struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
 void vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
 		    struct kvm_cpuid2 *cpuid);
@@ -322,10 +324,13 @@ kvm_get_supported_cpuid_entry(uint32_t function)
 }
 
 uint64_t vcpu_get_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index);
+int _vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
+		  uint64_t msr_value);
 void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
 	  	  uint64_t msr_value);
 
-uint32_t kvm_get_cpuid_max(void);
+uint32_t kvm_get_cpuid_max_basic(void);
+uint32_t kvm_get_cpuid_max_extended(void);
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 6698cb741e10..683d3bdb8f6a 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -869,7 +869,7 @@ uint64_t vcpu_get_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index)
 	return buffer.entry.data;
 }
 
-/* VCPU Set MSR
+/* _VCPU Set MSR
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -879,12 +879,12 @@ uint64_t vcpu_get_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index)
  *
  * Output Args: None
  *
- * Return: On success, nothing. On failure a TEST_ASSERT is produced.
+ * Return: The result of KVM_SET_MSRS.
  *
- * Set value of MSR for VCPU.
+ * Sets the value of an MSR for the given VCPU.
  */
-void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
-	uint64_t msr_value)
+int _vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
+		  uint64_t msr_value)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	struct {
@@ -899,6 +899,29 @@ void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
 	buffer.entry.index = msr_index;
 	buffer.entry.data = msr_value;
 	r = ioctl(vcpu->fd, KVM_SET_MSRS, &buffer.header);
+	return r;
+}
+
+/* VCPU Set MSR
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   vcpuid - VCPU ID
+ *   msr_index - Index of MSR
+ *   msr_value - New value of MSR
+ *
+ * Output Args: None
+ *
+ * Return: On success, nothing. On failure a TEST_ASSERT is produced.
+ *
+ * Set value of MSR for VCPU.
+ */
+void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
+	uint64_t msr_value)
+{
+	int r;
+
+	r = _vcpu_set_msr(vm, vcpuid, msr_index, msr_value);
 	TEST_ASSERT(r == 1, "KVM_SET_MSRS IOCTL failed,\n"
 		"  rc: %i errno: %i", r, errno);
 }
@@ -1000,19 +1023,45 @@ struct kvm_x86_state {
 	struct kvm_msrs msrs;
 };
 
-static int kvm_get_num_msrs(struct kvm_vm *vm)
+static int kvm_get_num_msrs_fd(int kvm_fd)
 {
 	struct kvm_msr_list nmsrs;
 	int r;
 
 	nmsrs.nmsrs = 0;
-	r = ioctl(vm->kvm_fd, KVM_GET_MSR_INDEX_LIST, &nmsrs);
+	r = ioctl(kvm_fd, KVM_GET_MSR_INDEX_LIST, &nmsrs);
 	TEST_ASSERT(r == -1 && errno == E2BIG, "Unexpected result from KVM_GET_MSR_INDEX_LIST probe, r: %i",
 		r);
 
 	return nmsrs.nmsrs;
 }
 
+static int kvm_get_num_msrs(struct kvm_vm *vm)
+{
+	return kvm_get_num_msrs_fd(vm->kvm_fd);
+}
+
+struct kvm_msr_list *kvm_get_msr_index_list(void)
+{
+	struct kvm_msr_list *list;
+	int nmsrs, r, kvm_fd;
+
+	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
+	if (kvm_fd < 0)
+		exit(KSFT_SKIP);
+
+	nmsrs = kvm_get_num_msrs_fd(kvm_fd);
+	list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
+	list->nmsrs = nmsrs;
+	r = ioctl(kvm_fd, KVM_GET_MSR_INDEX_LIST, list);
+	close(kvm_fd);
+
+	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_MSR_INDEX_LIST, r: %i",
+		r);
+
+	return list;
+}
+
 struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
@@ -1158,7 +1207,12 @@ bool is_intel_cpu(void)
 	return (ebx == chunk[0] && edx == chunk[1] && ecx == chunk[2]);
 }
 
-uint32_t kvm_get_cpuid_max(void)
+uint32_t kvm_get_cpuid_max_basic(void)
+{
+	return kvm_get_supported_cpuid_entry(0)->eax;
+}
+
+uint32_t kvm_get_cpuid_max_extended(void)
 {
 	return kvm_get_supported_cpuid_entry(0x80000000)->eax;
 }
@@ -1169,7 +1223,7 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 	bool pae;
 
 	/* SDM 4.1.4 */
-	if (kvm_get_cpuid_max() < 0x80000008) {
+	if (kvm_get_cpuid_max_extended() < 0x80000008) {
 		pae = kvm_get_supported_cpuid_entry(1)->edx & (1 << 6);
 		*pa_bits = pae ? 36 : 32;
 		*va_bits = 32;
diff --git a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
new file mode 100644
index 000000000000..851ea81b9d9f
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019, Google LLC.
+ *
+ * Tests for the IA32_XSS MSR.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "vmx.h"
+
+#define VCPU_ID	      1
+#define MSR_BITS      64
+
+#define X86_FEATURE_XSAVES	(1<<3)
+
+bool is_supported_msr(u32 msr_index)
+{
+	struct kvm_msr_list *list;
+	bool found = false;
+	int i;
+
+	list = kvm_get_msr_index_list();
+	for (i = 0; i < list->nmsrs; ++i) {
+		if (list->indices[i] == msr_index) {
+			found = true;
+			break;
+		}
+	}
+
+	free(list);
+	return found;
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_cpuid_entry2 *entry;
+	bool xss_supported = false;
+	struct kvm_vm *vm;
+	uint64_t xss_val;
+	int i, r;
+
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, 0);
+
+	if (kvm_get_cpuid_max_basic() >= 0xd) {
+		entry = kvm_get_supported_cpuid_index(0xd, 1);
+		xss_supported = entry && !!(entry->eax & X86_FEATURE_XSAVES);
+	}
+	if (!xss_supported) {
+		printf("IA32_XSS is not supported by the vCPU.\n");
+		exit(KSFT_SKIP);
+	}
+
+	xss_val = vcpu_get_msr(vm, VCPU_ID, MSR_IA32_XSS);
+	TEST_ASSERT(xss_val == 0,
+		    "MSR_IA32_XSS should be initialized to zero\n");
+
+	vcpu_set_msr(vm, VCPU_ID, MSR_IA32_XSS, xss_val);
+	/*
+	 * At present, KVM only supports a guest IA32_XSS value of 0. Verify
+	 * that trying to set the guest IA32_XSS to an unsupported value fails.
+	 * Also, in the future when a non-zero value succeeds check that
+	 * IA32_XSS is in the KVM_GET_MSR_INDEX_LIST.
+	 */
+	for (i = 0; i < MSR_BITS; ++i) {
+		r = _vcpu_set_msr(vm, VCPU_ID, MSR_IA32_XSS, 1ull << i);
+		TEST_ASSERT(r == 0 || is_supported_msr(MSR_IA32_XSS),
+			    "IA32_XSS was able to be set, but was not found in KVM_GET_MSR_INDEX_LIST.\n");
+	}
+
+	kvm_vm_free(vm);
+}
-- 
2.23.0.866.gb869b98d4c-goog

