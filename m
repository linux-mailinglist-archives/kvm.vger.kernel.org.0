Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABAED04DB
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 02:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbfJIAmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 20:42:21 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:35286 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729881AbfJIAmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 20:42:21 -0400
Received: by mail-pg1-f202.google.com with SMTP id s1so434117pgm.2
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 17:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2JlXV32dh3Qy0/myg6pgeOwLjaZKIAICdtqnMt/R3Js=;
        b=IXy0QzO4s4cEES2I9VLYVN26fpSHVaHQjrt53URoZjjJp5CGD3tIab+KJtyTOFYexB
         HJNmyL0D/30Lf0iDziBJ7V7pNMJKfk1bb4ggXU/JoW4+RXN62np/xtAQ0BjjGOzhmoWZ
         Wi72uUWB9DofRUUwQmE7npA5x6Tg0tYZNnvxFmzDwOuA0zq1D6X1M/onKET1+WAGo7kL
         1wm5lLIJcnpjLWxz2gFBEw+vjkJaS1mZyUIlBPjHAWNf/HTb/TkjwVm1t/h8jyJhhYES
         IikdZniC0JEIevzNIa0XwAUZODhCL40X7saMvBdn7ZPVGkh/uJF7JzsQ1w+9SDlwBpJd
         XYMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2JlXV32dh3Qy0/myg6pgeOwLjaZKIAICdtqnMt/R3Js=;
        b=tPNQLpFdJTxO4s3TsN78pC0GbzKYfvjgzLmeIN1+YiTTdt4GNavORzqqnCdkWzyBYv
         Nu4oQVSRscHepONEfvdghHdQEzZ+r0YBaL9PJIfTCRDrRoxwK44eNvUHleVzF0ePYZjK
         YStM3XBORphOAbQt1Ow1oTF3Wz7sJPP4hAZmtil+9JTSzl/cS4vYmfeEhBzOZ4bKW6eK
         w9sK0FN3e1++Yx7DVGxjZbNhqR4Go+wdwODbjbpybt8vdfeIsczNwwbdzGxDyCs35HC2
         93/CbwINt64NHA6213bYYnrcbE30IMESfSefjnI3dEQoRQlje+kt/gsgRkvOZMST86Ov
         ujCA==
X-Gm-Message-State: APjAAAXnE6AECaTzATxgVl1sfovk0gs4eNZJSr7S8uwxWiVvCoa/CZZJ
        0PjQEbChoERw+yq4JDp1tJ8UXksDXEsDtmsg
X-Google-Smtp-Source: APXvYqzD465jOBrpsFUdra8IN47Xg9RpARntDSso4xa/SjrDdRM/BGknOzvRB17p6aD7T3+3vYfRHvDqzQnxAvwZ
X-Received: by 2002:a65:4183:: with SMTP id a3mr1261759pgq.404.1570581740465;
 Tue, 08 Oct 2019 17:42:20 -0700 (PDT)
Date:   Tue,  8 Oct 2019 17:41:42 -0700
In-Reply-To: <20191009004142.225377-1-aaronlewis@google.com>
Message-Id: <20191009004142.225377-6-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191009004142.225377-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [Patch 6/6] kvm: tests: Add test to verify MSR_IA32_XSS
From:   Aaron Lewis <aaronlewis@google.com>
To:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>
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
 .../selftests/kvm/lib/x86_64/processor.c      | 69 ++++++++++++++++---
 .../selftests/kvm/x86_64/xss_msr_test.c       | 65 +++++++++++++++++
 5 files changed, 134 insertions(+), 9 deletions(-)
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
index ff234018219c..1dc55eea756a 100644
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
@@ -324,8 +326,11 @@ kvm_get_supported_cpuid_entry(uint32_t function)
 uint64_t vcpu_get_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index);
 void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
 	  	  uint64_t msr_value);
+void vcpu_set_msr_expect_result(struct kvm_vm *vm, uint32_t vcpuid,
+		  uint64_t msr_index, uint64_t msr_value, int result);
 
-uint32_t kvm_get_cpuid_max(void);
+uint32_t kvm_get_cpuid_max_basic(void);
+uint32_t kvm_get_cpuid_max_extended(void);
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 6698cb741e10..425262e15afa 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -869,13 +869,14 @@ uint64_t vcpu_get_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index)
 	return buffer.entry.data;
 }
 
-/* VCPU Set MSR
+/* VCPU Set MSR Expect Result
  *
  * Input Args:
  *   vm - Virtual Machine
  *   vcpuid - VCPU ID
  *   msr_index - Index of MSR
  *   msr_value - New value of MSR
+ *   result - The expected result of KVM_SET_MSRS
  *
  * Output Args: None
  *
@@ -883,8 +884,9 @@ uint64_t vcpu_get_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index)
  *
  * Set value of MSR for VCPU.
  */
-void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
-	uint64_t msr_value)
+void vcpu_set_msr_expect_result(struct kvm_vm *vm, uint32_t vcpuid,
+				uint64_t msr_index, uint64_t msr_value,
+				int result)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	struct {
@@ -899,10 +901,30 @@ void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
 	buffer.entry.index = msr_index;
 	buffer.entry.data = msr_value;
 	r = ioctl(vcpu->fd, KVM_SET_MSRS, &buffer.header);
-	TEST_ASSERT(r == 1, "KVM_SET_MSRS IOCTL failed,\n"
+	TEST_ASSERT(r == result, "KVM_SET_MSRS IOCTL failed,\n"
 		"  rc: %i errno: %i", r, errno);
 }
 
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
+	vcpu_set_msr_expect_result(vm, vcpuid, msr_index, msr_value, 1);
+}
+
 /* VM VCPU Args Set
  *
  * Input Args:
@@ -1000,19 +1022,45 @@ struct kvm_x86_state {
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
@@ -1158,7 +1206,12 @@ bool is_intel_cpu(void)
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
@@ -1169,7 +1222,7 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 	bool pae;
 
 	/* SDM 4.1.4 */
-	if (kvm_get_cpuid_max() < 0x80000008) {
+	if (kvm_get_cpuid_max_extended() < 0x80000008) {
 		pae = kvm_get_supported_cpuid_entry(1)->edx & (1 << 6);
 		*pa_bits = pae ? 36 : 32;
 		*va_bits = 32;
diff --git a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
new file mode 100644
index 000000000000..47060eff06ce
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
@@ -0,0 +1,65 @@
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
+	int i;
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
+		    "Support for IA32_XSS and support for XSAVES do not match.\n");
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
+	 */
+	vcpu_set_msr_expect_result(vm, VCPU_ID, MSR_IA32_XSS, ~0ull, 0);
+
+	free(list);
+	kvm_vm_free(vm);
+}
-- 
2.23.0.581.g78d2f28ef7-goog

