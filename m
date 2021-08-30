Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95FF3FBDB1
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 22:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbhH3U6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 16:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235846AbhH3U6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 16:58:20 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760BDC061764
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 13:57:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b9-20020a5b07890000b0290558245b7eabso8530530ybq.10
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 13:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XnX1RRTYlpNFCaeJ5FVd4ogAgvJWBNrKsE3lEqNCRUs=;
        b=hZcPaMjlZXhuJ2KjhtRHlGd1qP0hgyCBZQ0YxazNjI41dD60YsbjGLAHZVQR+XZUIp
         uxkrhcdARfHk94sXMUjL/i1iuuQEIWfQ47M6U064udi1+4qfkbEqm5OXb2dyhLlq+Srk
         QMdb1FAJWNLhtvWx9175XxYdyIzH863UWDGiRTIGmGwCSXOclu9O1hVKGLSmHahvUKlu
         nb+JckZ78raFp1GP34aLFGTLGkRPQ0UqkDZYiNqtGwUurPvZLjFFHp9TpGFOMpR8yFvf
         LYVCweJuXvgBtfUeq+oN4/9wiryERN9JDSvir/eNiF1xaPwi3iwNu7f1KNAPR7kxPvS1
         PeaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XnX1RRTYlpNFCaeJ5FVd4ogAgvJWBNrKsE3lEqNCRUs=;
        b=aZyy4SZ0SBkBs+9FwxmnaoJFfGLZNmR+KYJkjQpCVm+7IiBMl6TNrtbhDrgO1I4OzD
         qLEi3Gy5+NRYPu7AqArMQf1wd/9wjUgtgVveduFB1o8PAVxTc3VzexTNxHV7Bzfw8slV
         QCtaNndg+gzGNCV1jpjvyJfhtVSLuUuN1VDRKUCPUJL+H1w4xekkZfjHpTAAS/+8URj5
         5TNdBdgH+0yuFfuMepLVfdmL3RnzA3SNg5+bB53FDrsaq1E96+Kk46jE5+XkE/yX/s9X
         4l9XxgtA3fEUw0iLZ/w5jXH2ewpXxEYpoUO1NrDADbp0k790MJ0RMChzrRRbVp7XXeDK
         wzEg==
X-Gm-Message-State: AOAM5304ZpxvhekHFXJ5rH484WCA12FB0Q7QBLpWdbW5eEIEhb68X4e9
        gpq1CM3dYHWFihplMUhcijIEjCOv9bCrAdo/2ov9EPEKUQIwE2dgSTCQnFj5EgOdTO5ULvk1BT0
        KBcId9Yudx/CuhxCRT1IJKeFmUDnvi/3W3ymyXlg26Y+Y8mil/AYPqiWbQw==
X-Google-Smtp-Source: ABdhPJxJ+1mZc5XXrIfkAVvN6Ti+jU8EVPsZO4GbvjFKOrX69rGrtr2gCuiuxSayV4aIzwOViKScrQSuH/U=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:e552:6d5e:b69d:968c])
 (user=pgonda job=sendgmr) by 2002:a25:ea52:: with SMTP id o18mr28100655ybe.150.1630357045610;
 Mon, 30 Aug 2021 13:57:25 -0700 (PDT)
Date:   Mon, 30 Aug 2021 13:57:17 -0700
In-Reply-To: <20210830205717.3530483-1-pgonda@google.com>
Message-Id: <20210830205717.3530483-4-pgonda@google.com>
Mime-Version: 1.0
References: <20210830205717.3530483-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 3/3 V6] selftest: KVM: Add intra host migration
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adds testcases for intra host migration for SEV and SEV-ES. Also adds
locking test to confirm no deadlock exists.

---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/sev_vm_tests.c       | 152 ++++++++++++++++++
 2 files changed, 153 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_vm_tests.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 5832f510a16c..de6e64d5c9c4 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -71,6 +71,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
+TEST_GEN_PROGS_x86_64 += x86_64/sev_vm_tests
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c b/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c
new file mode 100644
index 000000000000..50a770316628
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/sev_vm_tests.c
@@ -0,0 +1,150 @@
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
+#include "kvm_util.h"
+#include "kselftest.h"
+#include "../lib/kvm_util_internal.h"
+
+#define SEV_DEV_PATH "/dev/sev"
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
+static void sev_ioctl(int fd, int cmd_id, void *data)
+{
+	struct kvm_sev_cmd cmd = { 0 };
+	int ret;
+
+	TEST_ASSERT(cmd_id < KVM_SEV_NR_MAX, "Unknown SEV CMD : %d\n", cmd_id);
+
+	cmd.id = cmd_id;
+	cmd.sev_fd = open_sev_dev_path_or_exit(0);
+	cmd.data = (uint64_t)data;
+	ret = ioctl(fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
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
+	for (i = 0; i < 3; ++i)
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
+	struct kvm_vm *vms[3];
+	struct kvm_enable_cap cap = { 0 };
+	int i;
+
+	for (i = 0; i < sizeof(vms) / sizeof(struct kvm_vm *); ++i)
+		vms[i] = sev_vm_create(es);
+
+	cap.cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM;
+	for (i = 0; i < sizeof(vms) / sizeof(struct kvm_vm *) - 1; ++i) {
+		cap.args[0] = vms[i]->fd;
+		vm_enable_cap(vms[i + 1], &cap);
+	}
+}
+
+#define LOCK_TESTING_THREADS 3
+
+struct locking_thread_input {
+	struct kvm_vm *vm;
+	int source_fds[LOCK_TESTING_THREADS];
+};
+
+static void *locking_test_thread(void *arg)
+{
+	struct kvm_enable_cap cap = { 0 };
+	int i, j;
+	struct locking_thread_input *input = (struct locking_test_thread *)arg;
+
+	cap.cap = KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM;
+
+	for (i = 0; i < 1000; ++i) {
+		j = input->source_fds[i % LOCK_TESTING_THREADS];
+		cap.args[0] = input->source_fds[j];
+		/*
+		 * Call IOCTL directly without checking return code. We are
+		 * simply trying to confirm there is no deadlock from userspace
+		 * not check correctness of migration here.
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
+	memcpy(input[1].source_fds, input[0].source_fds,
+	       sizeof(input[1].source_fds));
+	memcpy(input[2].source_fds, input[0].source_fds,
+	       sizeof(input[2].source_fds));
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
2.33.0.259.gc128427fd7-goog

