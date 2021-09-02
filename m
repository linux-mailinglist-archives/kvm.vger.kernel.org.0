Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC853FF321
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 20:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347000AbhIBST1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 14:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346954AbhIBSTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 14:19:05 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8C7C061757
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 11:18:06 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id c27-20020a05620a165b00b003d3817c7c23so3179439qko.16
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 11:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Sn+g2bADD404qqjx2up6VXRVrUYy8eh5xavXQUrq6zk=;
        b=YA/z9SWZizIuQlkt7Sah9G1tInnrR7SLQie53RYcf0VJIaF2AzSr1TfkmKDWUKTTdS
         ss7ynVvdbhCl5Xi4b5gC9125rH40UCFUN78/XN5LfTTOKKFcF5v6d0uKvuJKmO+aX5aK
         Lxp7zrrZE5oJjiK9hZySN1OB+mu5M+8wIyWif6P/9ifWehxROkhyrDdxxi6q0oSji/Ej
         KJgmTgxu0y1KXtDN5Vfxn3ewUIcFlt3Jn2//wcmhjc4VvLQQh8AISXjThuQfZGnUzDLi
         CGphYzq55Sb/RYdwW3tUvlqXVF8GeYc//IilYx7EgY+FgADgIjCqg0fGD/iUkSfq2pj7
         tldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Sn+g2bADD404qqjx2up6VXRVrUYy8eh5xavXQUrq6zk=;
        b=EJe3x3JIaNVg6rp7vJ4n/zUd1UapDlNl+XLvsGLcYGlE/Zfq/3lLpL4jMuW7gg5ZXf
         AuXnhEYFDOvIrydyf58UJvH0xbcm5y1vip4jMEII1psbGR//F8NSt7rrhdoouZpS2U3e
         KIySkLNPs1ZHzt+//gu+od6tCaOh092GF1wpVWLdvx7qslA/lBOBmGn8A67EbTeEz3iJ
         oBaF2Vlz4LUpAqKv7FI3CrOwv5juwsUOCwj2SPa119B5sHbJw89iFefQLUQvmPZXvudN
         a4FD4eptP9GGLlnmBMY9Xj8ZFZid7peUkg6iR/zEyKx+Z2sQAIDLHjv3IxfkybvuIaPB
         qYaQ==
X-Gm-Message-State: AOAM530RIHT+pAmtS0VYRNwOq7jbhbPfWGD1EmdygNNpIit2kfOna1fe
        AC2PbcqV5+1Amp7y/JAxH45KZM72Pj+tEav6BDYlDiq8oGkx5Vr5glf1rP51Hi4gEn7Q5mhCDDm
        0LngTSQwUdku3wUvz60VLpWk3tUdLmhYTZUHlMkBWBNow3H0P3KKDvEfPzQ==
X-Google-Smtp-Source: ABdhPJwcG8CnRLSx8mq6diZXX4lSPsxjiKeHD4iJow4eFxlcGB4nxa4pkFw1OzWn3WssEiBSwrC8rqJ21UY=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:faf4:6e40:7b4e:999f])
 (user=pgonda job=sendgmr) by 2002:a0c:be8e:: with SMTP id n14mr4314725qvi.16.1630606685750;
 Thu, 02 Sep 2021 11:18:05 -0700 (PDT)
Date:   Thu,  2 Sep 2021 11:17:51 -0700
In-Reply-To: <20210902181751.252227-1-pgonda@google.com>
Message-Id: <20210902181751.252227-4-pgonda@google.com>
Mime-Version: 1.0
References: <20210902181751.252227-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 3/3 V7] selftest: KVM: Add intra host migration tests
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adds testcases for intra host migration for SEV and SEV-ES. Also adds
locking test to confirm no deadlock exists.

Signed-off-by: Peter Gonda <pgonda@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/sev_vm_tests.c       | 159 ++++++++++++++++++
 2 files changed, 160 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_vm_tests.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c103873531e0..44fd3566fb51 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -72,6 +72,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_pi_mmio_test
+TEST_GEN_PROGS_x86_64 += x86_64/sev_vm_tests
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c b/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c
new file mode 100644
index 000000000000..8ce8dd63ca85
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c
@@ -0,0 +1,159 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kvm.h>
+#include <linux/psp-sev.h>
+#include <stdio.h>
+#include <sys/ioctl.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <pthread.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+#include "kselftest.h"
+#include "../lib/kvm_util_internal.h"
+
+#define SEV_DEV_PATH "/dev/sev"
+
+#define MIGRATE_TEST_NUM_VCPUS 4
+#define MIGRATE_TEST_VMS 3
+#define LOCK_TESTING_THREADS 3
+#define LOCK_TESTING_ITERATIONS 10000
+
+/*
+ * Open SEV_DEV_PATH if available, otherwise exit the entire program.
+ *
+ * Input Args:
+ *   flags - The flags to pass when opening SEV_DEV_PATH.
+ *
+ * Return:
+ *   The opened file descriptor of /dev/sev.
+ */
+static int open_sev_dev_path_or_exit(int flags)
+{
+	static int fd;
+
+	if (fd != 0)
+		return fd;
+
+	fd = open(SEV_DEV_PATH, flags);
+	if (fd < 0) {
+		print_skip("%s not available, is SEV not enabled? (errno: %d)",
+			   SEV_DEV_PATH, errno);
+		exit(KSFT_SKIP);
+	}
+
+	return fd;
+}
+
+static void sev_ioctl(int vm_fd, int cmd_id, void *data)
+{
+	struct kvm_sev_cmd cmd = {
+		.id = cmd_id,
+		.data = (uint64_t)data,
+		.sev_fd = open_sev_dev_path_or_exit(0),
+	};
+	int ret;
+
+	TEST_ASSERT(cmd_id < KVM_SEV_NR_MAX && cmd_id >= 0,
+		    "Unknown SEV CMD : %d\n", cmd_id);
+
+	ret = ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
+	TEST_ASSERT((ret == 0 || cmd.error == SEV_RET_SUCCESS),
+		    "%d failed: return code: %d, errno: %d, fw error: %d",
+		    cmd_id, ret, errno, cmd.error);
+}
+
+static struct kvm_vm *sev_vm_create(bool es)
+{
+	struct kvm_vm *vm;
+	struct kvm_sev_launch_start start = { 0 };
+	int i;
+
+	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
+	sev_ioctl(vm->fd, es ? KVM_SEV_ES_INIT : KVM_SEV_INIT, NULL);
+	for (i = 0; i < MIGRATE_TEST_NUM_VCPUS; ++i)
+		vm_vcpu_add(vm, i);
+	start.policy |= (es) << 2;
+	sev_ioctl(vm->fd, KVM_SEV_LAUNCH_START, &start);
+	if (es)
+		sev_ioctl(vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
+	return vm;
+}
+
+static void test_sev_migrate_from(bool es)
+{
+	struct kvm_vm *vms[MIGRATE_TEST_VMS];
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM
+	};
+	int i;
+
+	for (i = 0; i < MIGRATE_TEST_VMS; ++i) {
+		vms[i] = sev_vm_create(es);
+		if (i > 0) {
+			cap.args[0] = vms[i - 1]->fd;
+			vm_enable_cap(vms[i], &cap);
+		}
+	}
+}
+
+struct locking_thread_input {
+	struct kvm_vm *vm;
+	int source_fds[LOCK_TESTING_THREADS];
+};
+
+static void *locking_test_thread(void *arg)
+{
+	/*
+	 * This test case runs a number of threads all trying to use the intra
+	 * host migration ioctls. This tries to detect if a deadlock exists.
+	 */
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM
+	};
+	int i, j;
+	struct locking_thread_input *input = (struct locking_test_thread *)arg;
+
+	for (i = 0; i < LOCK_TESTING_ITERATIONS; ++i) {
+		j = input->source_fds[i % LOCK_TESTING_THREADS];
+		cap.args[0] = input->source_fds[j];
+		/*
+		 * Call IOCTL directly without checking return code or
+		 * asserting. We are * simply trying to confirm there is no
+		 * deadlock from userspace * not check correctness of
+		 * migration here.
+		 */
+		ioctl(input->vm->fd, KVM_ENABLE_CAP, &cap);
+	}
+}
+
+static void test_sev_migrate_locking(void)
+{
+	struct locking_thread_input input[LOCK_TESTING_THREADS];
+	pthread_t pt[LOCK_TESTING_THREADS];
+	int i;
+
+	for (i = 0; i < LOCK_TESTING_THREADS; ++i) {
+		input[i].vm = sev_vm_create(/* es= */ false);
+		input[0].source_fds[i] = input[i].vm->fd;
+	}
+	for (i = 1; i < LOCK_TESTING_THREADS; ++i)
+		memcpy(input[i].source_fds, input[0].source_fds,
+		       sizeof(input[i].source_fds));
+
+	for (i = 0; i < LOCK_TESTING_THREADS; ++i)
+		pthread_create(&pt[i], NULL, locking_test_thread, &input[i]);
+
+	for (i = 0; i < LOCK_TESTING_THREADS; ++i)
+		pthread_join(pt[i], NULL);
+}
+
+int main(int argc, char *argv[])
+{
+	test_sev_migrate_from(/* es= */ false);
+	test_sev_migrate_from(/* es= */ true);
+	test_sev_migrate_locking();
+	return 0;
+}
-- 
2.33.0.153.gba50c8fa24-goog

