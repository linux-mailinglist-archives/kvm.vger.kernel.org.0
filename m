Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD8AF121E6
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 20:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfEBScC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 14:32:02 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:47101 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBScC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 14:32:02 -0400
Received: by mail-pf1-f201.google.com with SMTP id a141so1677340pfa.13
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 11:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6W8YxXEt9INznVZ8jDt0QnQo3oXYaMlB5EW9yc/FZIw=;
        b=XZE/P7JqKOYnZd5Hcaoz9li4iM6CUNdBnP/izFXruLTDVcncY0LnnLIHS4zAVWNE6y
         YJgDDrRHKW/TUVmeWqeItkxEloizMQehCmNkXEWHepfCp4ds0VnB4LNEzQaitsxdvkgH
         t/d2x2FYUFlaXdyOPlk46FujL08AOCRhWX7aiRZiMpZXYExSMe/5nUoLlJA5J72twazw
         BfovdUoVIGvS7NwaJ9DhsgCwRIq/UItMHY9fUZinnwZcN2OXivmOlSr3RBKuw6HyrWuS
         QAP2bSkuiorkZ0SNMqucn0c8+ZgEYHs+j9Ozk3TJ7Obl9YAVYMY92hb0HANXtU9tF65/
         6MQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6W8YxXEt9INznVZ8jDt0QnQo3oXYaMlB5EW9yc/FZIw=;
        b=rOtmavk/ueDXOCxQK71UUgwp3u4u28y4mQ91vIli82fR9KHpscEO59PW4BqWWmPcfo
         ln7a08+TjrwgTZcgYC+Ee863C5dgRnBMszqluouRkdfQ0T1tmfv/9GZswn3nMwn5pJ3A
         EUbspmweD/cZ+58tD+THnzemB7XeN8jR4N4onbPF3ALo1V0dROSrkfVfdSCI/Ae+2u1p
         MvEm/Y9ok93w9CMN/4V8soCNDjj7UE0SqjGm9ccJj1QcCK1vlV4dsxU02rUeF8QnhXBH
         xEhQxTHVHEv33oNTwWOX/mRaYnlUsgCZuDM0Ff2CTpLZphWM2aMoCN0GNNURZkUyL567
         NrwA==
X-Gm-Message-State: APjAAAWI5AZ/XddERcgl5h8UPome8EupSZ9mWgzeFWRtXr0pyBk/xSdK
        8dfV5t3vppVmNC+t03BeZ96p6RU0H6N7i1zl
X-Google-Smtp-Source: APXvYqyHF7W1674jYoxpufqchbPR3VNcb7/2RLER8eHvNfnqSTcOvtOpdPBIOvF884JGMt+yNiK8GM1TFwsiTCig
X-Received: by 2002:a63:ef4c:: with SMTP id c12mr5611889pgk.43.1556821921781;
 Thu, 02 May 2019 11:32:01 -0700 (PDT)
Date:   Thu,  2 May 2019 11:31:59 -0700
Message-Id: <20190502183159.260545-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH] tests: kvm: Add tests for KVM_CAP_MAX_VCPUS and KVM_CAP_MAX_CPU_ID
From:   Aaron Lewis <aaronlewis@google.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        marcorr@google.com, kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../kvm/x86_64/kvm_create_max_vcpus.c         | 70 +++++++++++++++++++
 3 files changed, 72 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 2689d1ea6d7a..98d93c0fd38e 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -6,4 +6,5 @@
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_tsc_adjust_test
 /x86_64/state_test
+/x86_64/kvm_create_max_vcpus
 /dirty_log_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index f8588cca2bef..6b7b3617d25c 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -20,6 +20,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/smm_test
+TEST_GEN_PROGS_x86_64 += x86_64/kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c
new file mode 100644
index 000000000000..50e92996f918
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c
@@ -0,0 +1,70 @@
+/*
+ * kvm_create_max_vcpus
+ *
+ * Copyright (C) 2019, Google LLC.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ *
+ * Test for KVM_CAP_MAX_VCPUS and KVM_CAP_MAX_VCPU_ID.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "test_util.h"
+
+#include "kvm_util.h"
+#include "asm/kvm.h"
+#include "linux/kvm.h"
+
+void test_vcpu_creation(int first_vcpu_id, int num_vcpus)
+{
+	struct kvm_vm *vm;
+	int i;
+
+	printf("Testing creating %d vCPUs, with IDs %d...%d.\n",
+	       num_vcpus, first_vcpu_id, first_vcpu_id + num_vcpus - 1);
+
+	vm = vm_create(VM_MODE_P52V48_4K, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+
+	for (i = 0; i < num_vcpus; i++) {
+		int vcpu_id = first_vcpu_id + i;
+
+		/* This asserts that the vCPU was created. */
+		vm_vcpu_add(vm, vcpu_id, 0, 0);
+	}
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	int kvm_max_vcpu_id = kvm_check_cap(KVM_CAP_MAX_VCPU_ID);
+	int kvm_max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
+
+	printf("KVM_CAP_MAX_VCPU_ID: %d\n", kvm_max_vcpu_id);
+	printf("KVM_CAP_MAX_VCPUS: %d\n", kvm_max_vcpus);
+
+	/*
+	 * Upstream KVM prior to 4.8 does not support KVM_CAP_MAX_VCPU_ID.
+	 * Userspace is supposed to use KVM_CAP_MAX_VCPUS as the maximum ID
+	 * in this case.
+	 */
+	if (!kvm_max_vcpu_id)
+		kvm_max_vcpu_id = kvm_max_vcpus;
+
+	TEST_ASSERT(kvm_max_vcpu_id >= kvm_max_vcpus,
+		    "KVM_MAX_VCPU_ID (%d) must be at least as large as KVM_MAX_VCPUS (%d).",
+		    kvm_max_vcpu_id, kvm_max_vcpus);
+
+	test_vcpu_creation(0, kvm_max_vcpus);
+
+	if (kvm_max_vcpu_id > kvm_max_vcpus)
+		test_vcpu_creation(
+			kvm_max_vcpu_id - kvm_max_vcpus, kvm_max_vcpus);
+
+	return 0;
+}
-- 
2.21.0.593.g511ec345e18-goog

