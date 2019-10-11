Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464E7D489A
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 21:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbfJKTlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 15:41:16 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:35436 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728985AbfJKTlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 15:41:16 -0400
Received: by mail-pl1-f202.google.com with SMTP id o12so6652798pll.2
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2019 12:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uigccOC75UQVYGcTvnAyLucq/FZ2h1PCnP1UNKyHaxs=;
        b=spE3SI/tGJXcTgjoJJxWOj/KdkWX0410GrN0KcOwG4VW9rZYSS/wuVhc82WkTWDuo7
         aXLJ+16OZRQAiZoRtH6JD81rsKHkXjk9thEvAq/vlxTCXpfXeifqABYSFGLK6L2higcK
         tWDA/rvHFtPFwzQNvblwJ2PL0nKDmFbR/B8C5wy1xUC24hZKtUx3mSQRWtSbYQFoxz2s
         Nu9g8MZ/nSBfTdGAXkIvhmjIzfKWuHGGMAVvXf95+PfPvlZUQHQzj+2XWrB8K60VQzhr
         cdh0bcTFkAdNuWObxSUiGO3RR43qN2IKIgj386ZGkuZLxV3oCnvOrv7Pv9Q1wQdCj+z1
         xubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uigccOC75UQVYGcTvnAyLucq/FZ2h1PCnP1UNKyHaxs=;
        b=Y0jdcw5GmJc87L63gmu9rhSwVw9Tlj8s2RWZjNDlf9BvcmPM8avl9yp/o13LuFiOPt
         d5kbISSgBCj6jY9oxQLhe8VVWpmP9rexjGaYWjfN/XynKwf0Wk450i/SOHih3Ue8SYw0
         MsRGsO3tCdXRGw4xVbv1lV+ehbzbCDOnW+GIdM4Buiwfz+v9qUEi6Zbet9Gb+g4SFVop
         BTriOL+YOFewj9/pI7zmYtyHvUMNBQGoCGDIqv8v/qoZFIUWmaIk73gaKEM743KCiCrq
         kiX2dkAAvcARZfW7bTUMGdfdR3vevvYvJYq3/92fTW5ZJ5uK+9HW2X7mJis59/u8IBS6
         cX0g==
X-Gm-Message-State: APjAAAWr6IufDYjuGDYUBf8L0v6pXRn/V26NAP7Z6p78E+r0oCSqMfAl
        IX7i5e0jPvbHtBwIoINFXamBjx0KMxDxanOG
X-Google-Smtp-Source: APXvYqzhYsMJnMSrzhwSujmHuTAOVj0OLASdf47quEOEGjwuXvyT01Gvfpa1Rn1yK7XLdGLnZYYEyOL+jhO5vpXm
X-Received: by 2002:a63:e156:: with SMTP id h22mr18232130pgk.266.1570822874169;
 Fri, 11 Oct 2019 12:41:14 -0700 (PDT)
Date:   Fri, 11 Oct 2019 12:40:32 -0700
In-Reply-To: <20191011194032.240572-1-aaronlewis@google.com>
Message-Id: <20191011194032.240572-6-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191011194032.240572-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH v2 5/5] kvm: tests: Add test to verify MSR_IA32_XSS
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

Verify that calling get and set for MSR_IA32_XSS returns expected results.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/include/x86_64/processor.h  |  7 +-
 .../selftests/kvm/lib/x86_64/processor.c      | 72 ++++++++++++++++---
 .../selftests/kvm/x86_64/xss_msr_test.c       | 70 ++++++++++++++++++
 5 files changed, 141 insertions(+), 10 deletions(-)
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
index 000000000000..17db23336673
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
@@ -0,0 +1,70 @@
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
+
+#define X86_FEATURE_XSAVES	(1<<3)
+
+int main(int argc, char *argv[])
+{
+	struct kvm_cpuid_entry2 *entry;
+	struct kvm_msr_list *list;
+	bool found_xss = false;
+	struct kvm_vm *vm;
+	uint64_t xss_val;
+	int i, r;
+
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, 0);
+
+	list = kvm_get_msr_index_list();
+	for (i = 0; i < list->nmsrs; ++i) {
+		if (list->indices[i] == MSR_IA32_XSS) {
+			found_xss = true;
+			break;
+		}
+	}
+
+	if (kvm_get_cpuid_max_basic() < 0xd) {
+		printf("XSAVES is not supported by the CPU.\n");
+		exit(KSFT_SKIP);
+	}
+
+	entry = kvm_get_supported_cpuid_index(0xd, 1);
+	TEST_ASSERT(found_xss == !!(entry->eax & X86_FEATURE_XSAVES),
+		    "Support for IA32_XSS and support for XSAVES do not match.");
+
+	if (!found_xss) {
+		printf("IA32_XSS and XSAVES are not supported.  Skipping test.\n");
+		exit(KSFT_SKIP);
+	}
+
+	xss_val = vcpu_get_msr(vm, VCPU_ID, MSR_IA32_XSS);
+	TEST_ASSERT(xss_val == 0, "MSR_IA32_XSS should always be zero\n");
+
+	vcpu_set_msr(vm, VCPU_ID, MSR_IA32_XSS, xss_val);
+	/*
+	 * At present, KVM only supports a guest IA32_XSS value of 0. Verify
+	 * that trying to set the guest IA32_XSS to an unsupported value fails.
+	 *
+	 * Using '1' which is an illegal value since bit 0 is x87 state, which
+	 * is covered by XCR0.
+	 */
+	r = _vcpu_set_msr(vm, VCPU_ID, MSR_IA32_XSS, 1);
+	TEST_ASSERT(r == 0,
+		    "KVM_SET_MSRS IOCTL failed,\n  rc: %i errno: %i", r, errno);
+
+	free(list);
+	kvm_vm_free(vm);
+}
-- 
2.23.0.700.g56cf767bdb-goog

