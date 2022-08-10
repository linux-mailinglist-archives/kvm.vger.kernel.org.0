Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C1258EF51
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 17:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbiHJPVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 11:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbiHJPVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 11:21:06 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5783D2C107
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:20:53 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id w124-20020a627b82000000b0052d8ebfc055so6631556pfc.19
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=MYDneT9H7RvPrT4sQm2b7/RZ8hQa6oRFixYULN4aLD0=;
        b=ADHokTmJ6vmz+4RmPqJu6qZDkzj4Eqrp2Hx9s7Rw3Fp60TLKLE8P0thDD6vw95FSNV
         Kbht5qTLyRrPjAKP2OGYPaBBOB+aVcXj1q4OxykCo1oC6QwXobn597NfQ+FmzOlNtEYq
         19M2P413wWe8FL8djY1FZieP3hKyyg+ABV7E+VVJulOPLaRyEmJDjgYYsNXrByL+8Dqh
         +l8zQFEyUC6av/1j2tNikD2PKqXpje8QOn6bZbYNSvnnjrjA0R+fdX2E5p2jUWKRBqOe
         Gb/+T8YF81kiLdoJ6rcpSOHFSh3Kv1OVBH1BURAIYaIKnw18dr3SUKdXI+J+K2DdLgkc
         Khtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=MYDneT9H7RvPrT4sQm2b7/RZ8hQa6oRFixYULN4aLD0=;
        b=o2bAQh6TbO6il9eht4EwwqNjEmQFUVQocP4BnzmljzVzXhZXgxWs12XRE7cfSwrbVu
         BXR3QUmXYjgRRqR1yY28n1rzYwK0AExNAXtDKkbVuU8MFkZQMsFCGjYi3SbSk6ebb/+y
         B+X1nJ6a26eXaMfv8GV3pQCbx092mfo1izdcDAm3zCPnhqy0JGu4NNjWIDz0NzAko7Q2
         jvNsr7mYAxhj4vB/0MNdfqGCOZgykmpoK6e2u0nRhtkxu5RtVQ5pl4YDhuYKLdBkZ0yG
         q9Msa/lFh71ZTUn/AIG5lVbVNxCuelr26Ps4DMs8qOAWdIn3cziB2iDZCyfeq7qFiEo/
         6/KA==
X-Gm-Message-State: ACgBeo3qZr7pVmbWb7FsxNrnda11PoeH9lzBRcd7jgIv5svP+UpD/yEU
        7Wqv3H1R5Nrma2wXCY1UKTs0zfrDk+rBV6VAYadwfjguyCiViDzhjQGIRCdUqNlJ8b7L0lVUw8T
        wsY3J4m/APNGA2iRl2fSPNLh+hR2bNUV6jfHMTnT19qVmzAq2BiEyAaTHTA==
X-Google-Smtp-Source: AA6agR6bY879bHVdbLdyS0jOQNYO9JhQy28/k9lofXPwQi+SIhVs99xzPzu4nxWxFIPFCfgxw19CHcz/lEY=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:b185:1827:5b23:bbe2])
 (user=pgonda job=sendgmr) by 2002:a17:90a:df03:b0:1f3:396c:dd94 with SMTP id
 gp3-20020a17090adf0300b001f3396cdd94mr250371pjb.1.1660144851264; Wed, 10 Aug
 2022 08:20:51 -0700 (PDT)
Date:   Wed, 10 Aug 2022 08:20:30 -0700
In-Reply-To: <20220810152033.946942-1-pgonda@google.com>
Message-Id: <20220810152033.946942-9-pgonda@google.com>
Mime-Version: 1.0
References: <20220810152033.946942-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [V3 08/11] KVM: selftests: add library for creating/interacting with
 SEV guests
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, vannapurve@google.com,
        Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Roth <michael.roth@amd.com>

Add interfaces to allow tests to create/manage SEV guests. The
additional state associated with these guests is encapsulated in a new
struct sev_vm, which is a light wrapper around struct kvm_vm. These
VMs will use vm_set_memory_encryption() and vm_get_encrypted_phy_pages()
under the covers to configure and sync up with the core kvm_util
library on what should/shouldn't be treated as encrypted memory.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/kvm_util_base.h     |   3 +
 .../selftests/kvm/include/x86_64/sev.h        |  44 +++
 tools/testing/selftests/kvm/lib/x86_64/sev.c  | 251 ++++++++++++++++++
 4 files changed, 299 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 39fc5e8e5594..b247c4b595af 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -55,6 +55,7 @@ LIBKVM_x86_64 += lib/x86_64/processor.c
 LIBKVM_x86_64 += lib/x86_64/svm.c
 LIBKVM_x86_64 += lib/x86_64/ucall.c
 LIBKVM_x86_64 += lib/x86_64/vmx.c
+LIBKVM_x86_64 += lib/x86_64/sev.c
 
 LIBKVM_aarch64 += lib/aarch64/gic.c
 LIBKVM_aarch64 += lib/aarch64/gic_v3.c
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 8ce9e5be70a3..1a84d2d1d85b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -68,6 +68,7 @@ struct userspace_mem_regions {
 /* Memory encryption policy/configuration. */
 struct vm_memcrypt {
 	bool enabled;
+	bool encrypted;
 	int8_t enc_by_default;
 	bool has_enc_bit;
 	int8_t enc_bit;
@@ -816,6 +817,8 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
 
 static inline vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
+	TEST_ASSERT(!vm->memcrypt.encrypted,
+		    "Encrypted guests have their page tables encrypted so gva2gpa conversions are not possible.");
 	return addr_arch_gva2gpa(vm, gva);
 }
 
diff --git a/tools/testing/selftests/kvm/include/x86_64/sev.h b/tools/testing/selftests/kvm/include/x86_64/sev.h
new file mode 100644
index 000000000000..2f7f7c741b12
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/sev.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Helpers used for SEV guests
+ *
+ * Copyright (C) 2021 Advanced Micro Devices
+ */
+#ifndef SELFTEST_KVM_SEV_H
+#define SELFTEST_KVM_SEV_H
+
+#include <stdint.h>
+#include <stdbool.h>
+#include "kvm_util.h"
+
+/* Makefile might set this separately for user-overrides */
+#ifndef SEV_DEV_PATH
+#define SEV_DEV_PATH		"/dev/sev"
+#endif
+
+#define SEV_FW_REQ_VER_MAJOR	0
+#define SEV_FW_REQ_VER_MINOR	17
+
+#define SEV_POLICY_NO_DBG	(1UL << 0)
+#define SEV_POLICY_ES		(1UL << 2)
+
+enum {
+	SEV_GSTATE_UNINIT = 0,
+	SEV_GSTATE_LUPDATE,
+	SEV_GSTATE_LSECRET,
+	SEV_GSTATE_RUNNING,
+};
+
+struct sev_vm;
+
+void kvm_sev_ioctl(struct sev_vm *sev, int cmd, void *data);
+struct kvm_vm *sev_get_vm(struct sev_vm *sev);
+uint8_t sev_get_enc_bit(struct sev_vm *sev);
+
+struct sev_vm *sev_vm_create(uint32_t policy, uint64_t npages);
+void sev_vm_free(struct sev_vm *sev);
+void sev_vm_launch(struct sev_vm *sev);
+void sev_vm_launch_measure(struct sev_vm *sev, uint8_t *measurement);
+void sev_vm_launch_finish(struct sev_vm *sev);
+
+#endif /* SELFTEST_KVM_SEV_H */
diff --git a/tools/testing/selftests/kvm/lib/x86_64/sev.c b/tools/testing/selftests/kvm/lib/x86_64/sev.c
new file mode 100644
index 000000000000..3abcf50c0b5d
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86_64/sev.c
@@ -0,0 +1,251 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Helpers used for SEV guests
+ *
+ * Copyright (C) 2021 Advanced Micro Devices
+ */
+
+#include <stdint.h>
+#include <stdbool.h>
+#include "kvm_util.h"
+#include "linux/psp-sev.h"
+#include "processor.h"
+#include "sev.h"
+
+#define PAGE_SHIFT		12
+#define CPUID_MEM_ENC_LEAF 0x8000001f
+#define CPUID_EBX_CBIT_MASK 0x3f
+
+struct sev_vm {
+	struct kvm_vm *vm;
+	int fd;
+	int enc_bit;
+	uint32_t sev_policy;
+};
+
+/* Common SEV helpers/accessors. */
+
+struct kvm_vm *sev_get_vm(struct sev_vm *sev)
+{
+	return sev->vm;
+}
+
+uint8_t sev_get_enc_bit(struct sev_vm *sev)
+{
+	return sev->enc_bit;
+}
+
+void sev_ioctl(int sev_fd, int cmd, void *data)
+{
+	int ret;
+	struct sev_issue_cmd arg;
+
+	arg.cmd = cmd;
+	arg.data = (unsigned long)data;
+	ret = ioctl(sev_fd, SEV_ISSUE_CMD, &arg);
+	TEST_ASSERT(ret == 0,
+		    "SEV ioctl %d failed, error: %d, fw_error: %d",
+		    cmd, ret, arg.error);
+}
+
+void kvm_sev_ioctl(struct sev_vm *sev, int cmd, void *data)
+{
+	struct kvm_sev_cmd arg = {0};
+	int ret;
+
+	arg.id = cmd;
+	arg.sev_fd = sev->fd;
+	arg.data = (__u64)data;
+
+	ret = ioctl(sev->vm->fd, KVM_MEMORY_ENCRYPT_OP, &arg);
+	TEST_ASSERT(ret == 0,
+		    "SEV KVM ioctl %d failed, rc: %i errno: %i (%s), fw_error: %d",
+		    cmd, ret, errno, strerror(errno), arg.error);
+}
+
+/* Local helpers. */
+
+static void
+sev_register_user_region(struct sev_vm *sev, void *hva, uint64_t size)
+{
+	struct kvm_enc_region range = {0};
+	int ret;
+
+	pr_debug("%s: hva: %p, size: %lu\n", __func__, hva, size);
+
+	range.addr = (__u64)hva;
+	range.size = size;
+
+	ret = ioctl(sev->vm->fd, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
+	TEST_ASSERT(ret == 0, "failed to register user range, errno: %i\n", errno);
+}
+
+static void
+sev_encrypt_phy_range(struct sev_vm *sev, vm_paddr_t gpa, uint64_t size)
+{
+	struct kvm_sev_launch_update_data ksev_update_data = {0};
+
+	pr_debug("%s: addr: 0x%lx, size: %lu\n", __func__, gpa, size);
+
+	ksev_update_data.uaddr = (__u64)addr_gpa2hva(sev->vm, gpa);
+	ksev_update_data.len = size;
+
+	kvm_sev_ioctl(sev, KVM_SEV_LAUNCH_UPDATE_DATA, &ksev_update_data);
+}
+
+static void sev_encrypt(struct sev_vm *sev)
+{
+	const struct sparsebit *enc_phy_pages;
+	struct kvm_vm *vm = sev->vm;
+	sparsebit_idx_t pg = 0;
+	vm_paddr_t gpa_start;
+	uint64_t memory_size;
+
+	/* Only memslot 0 supported for now. */
+	enc_phy_pages = vm_get_encrypted_phy_pages(sev->vm, 0, &gpa_start, &memory_size);
+	TEST_ASSERT(enc_phy_pages, "Unable to retrieve encrypted pages bitmap");
+	while (pg < (memory_size / vm->page_size)) {
+		sparsebit_idx_t pg_cnt;
+
+		if (sparsebit_is_clear(enc_phy_pages, pg)) {
+			pg = sparsebit_next_set(enc_phy_pages, pg);
+			if (!pg)
+				break;
+		}
+
+		pg_cnt = sparsebit_next_clear(enc_phy_pages, pg) - pg;
+		if (pg_cnt <= 0)
+			pg_cnt = 1;
+
+		sev_encrypt_phy_range(sev,
+				      gpa_start + pg * vm->page_size,
+				      pg_cnt * vm->page_size);
+		pg += pg_cnt;
+	}
+
+	sev->vm->memcrypt.encrypted = true;
+}
+
+/* SEV VM implementation. */
+
+static struct sev_vm *sev_vm_alloc(struct kvm_vm *vm)
+{
+	struct sev_user_data_status sev_status = {0};
+	uint32_t eax, ebx, ecx, edx;
+	struct sev_vm *sev;
+	int sev_fd;
+
+	sev_fd = open(SEV_DEV_PATH, O_RDWR);
+	if (sev_fd < 0) {
+		pr_info("Failed to open SEV device, path: %s, error: %d, skipping test.\n",
+			SEV_DEV_PATH, sev_fd);
+		return NULL;
+	}
+
+	sev_ioctl(sev_fd, SEV_PLATFORM_STATUS, &sev_status);
+
+	if (!(sev_status.api_major > SEV_FW_REQ_VER_MAJOR ||
+	      (sev_status.api_major == SEV_FW_REQ_VER_MAJOR &&
+	       sev_status.api_minor >= SEV_FW_REQ_VER_MINOR))) {
+		pr_info("SEV FW version too old. Have API %d.%d (build: %d), need %d.%d, skipping test.\n",
+			sev_status.api_major, sev_status.api_minor, sev_status.build,
+			SEV_FW_REQ_VER_MAJOR, SEV_FW_REQ_VER_MINOR);
+		return NULL;
+	}
+
+	sev = calloc(1, sizeof(*sev));
+	sev->fd = sev_fd;
+	sev->vm = vm;
+
+	/* Get encryption bit via CPUID. */
+	cpuid(CPUID_MEM_ENC_LEAF, &eax, &ebx, &ecx, &edx);
+	sev->enc_bit = ebx & CPUID_EBX_CBIT_MASK;
+
+	return sev;
+}
+
+void sev_vm_free(struct sev_vm *sev)
+{
+	ucall_uninit(sev->vm);
+	kvm_vm_free(sev->vm);
+	close(sev->fd);
+	free(sev);
+}
+
+struct sev_vm *sev_vm_create(uint32_t policy, uint64_t npages)
+{
+	struct sev_vm *sev;
+	struct kvm_vm *vm;
+
+	/* Need to handle memslots after init, and after setting memcrypt. */
+	vm = vm_create_barebones();
+	sev = sev_vm_alloc(vm);
+	if (!sev)
+		return NULL;
+	sev->sev_policy = policy;
+
+	kvm_sev_ioctl(sev, KVM_SEV_INIT, NULL);
+
+	vm->vpages_mapped = sparsebit_alloc();
+	vm_set_memory_encryption(vm, true, true, sev->enc_bit);
+	pr_info("SEV cbit: %d\n", sev->enc_bit);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, npages, 0);
+	sev_register_user_region(sev, addr_gpa2hva(vm, 0),
+				 npages * vm->page_size);
+
+	pr_info("SEV guest created, policy: 0x%x, size: %lu KB\n",
+		sev->sev_policy, npages * vm->page_size / 1024);
+
+	return sev;
+}
+
+void sev_vm_launch(struct sev_vm *sev)
+{
+	struct kvm_sev_launch_start ksev_launch_start = {0};
+	struct kvm_sev_guest_status ksev_status = {0};
+
+	/* Need to use ucall_shared for synchronization. */
+	//ucall_init_ops(sev_get_vm(sev), NULL, &ucall_ops_halt);
+
+	ksev_launch_start.policy = sev->sev_policy;
+	kvm_sev_ioctl(sev, KVM_SEV_LAUNCH_START, &ksev_launch_start);
+	kvm_sev_ioctl(sev, KVM_SEV_GUEST_STATUS, &ksev_status);
+	TEST_ASSERT(ksev_status.policy == sev->sev_policy, "Incorrect guest policy.");
+	TEST_ASSERT(ksev_status.state == SEV_GSTATE_LUPDATE,
+		    "Unexpected guest state: %d", ksev_status.state);
+
+	ucall_init(sev->vm, NULL);
+
+	sev_encrypt(sev);
+}
+
+void sev_vm_launch_measure(struct sev_vm *sev, uint8_t *measurement)
+{
+	struct kvm_sev_launch_measure ksev_launch_measure = {0};
+	struct kvm_sev_guest_status ksev_guest_status = {0};
+
+	ksev_launch_measure.len = 256;
+	ksev_launch_measure.uaddr = (__u64)measurement;
+	kvm_sev_ioctl(sev, KVM_SEV_LAUNCH_MEASURE, &ksev_launch_measure);
+
+	/* Measurement causes a state transition, check that. */
+	kvm_sev_ioctl(sev, KVM_SEV_GUEST_STATUS, &ksev_guest_status);
+	TEST_ASSERT(ksev_guest_status.state == SEV_GSTATE_LSECRET,
+		    "Unexpected guest state: %d", ksev_guest_status.state);
+}
+
+void sev_vm_launch_finish(struct sev_vm *sev)
+{
+	struct kvm_sev_guest_status ksev_status = {0};
+
+	kvm_sev_ioctl(sev, KVM_SEV_GUEST_STATUS, &ksev_status);
+	TEST_ASSERT(ksev_status.state == SEV_GSTATE_LUPDATE ||
+		    ksev_status.state == SEV_GSTATE_LSECRET,
+		    "Unexpected guest state: %d", ksev_status.state);
+
+	kvm_sev_ioctl(sev, KVM_SEV_LAUNCH_FINISH, NULL);
+
+	kvm_sev_ioctl(sev, KVM_SEV_GUEST_STATUS, &ksev_status);
+	TEST_ASSERT(ksev_status.state == SEV_GSTATE_RUNNING,
+		    "Unexpected guest state: %d", ksev_status.state);
+}
-- 
2.37.1.559.g78731f0fdb-goog

