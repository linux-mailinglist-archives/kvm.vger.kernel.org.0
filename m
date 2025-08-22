Return-Path: <kvm+bounces-55491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AD434B31131
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 10:06:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0759DB64D4C
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 08:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00E752EBB8E;
	Fri, 22 Aug 2025 08:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xr43KDVn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3E12AD20;
	Fri, 22 Aug 2025 08:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755849833; cv=none; b=MbrXqqoa1T2iFwkN+aRRun9AzKw4mccTnIVWGEvAZce4ddQu+G9Lrp3pJ+4cnN1NAKABIbRjjigcK4dZ34TvpFcmrawOxSkXuyHBnNSw7dgsTquwpdit2KtK+1U5CptVhWWcRaexYMWJQrvjxK5/olww486rQgm/Zg6FLgXtq/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755849833; c=relaxed/simple;
	bh=PncTHgIjF3nJ8qLaY+C8va7O1RZ8dN4JMH8eZV6EYQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRZwQrQ4gIkgfUJIgfInaTJp6aF0WvlV4IvtjFFtw9Jq4kSSkC8iI1EQiHam9mXjisMQa6cthGLtys50q/eo8+wK2aG3xJDuAfgqDHqisC8j5QO5sQHa0J4p+jg9k4YcmdbrJVJzwIUxaNf9UtQMFOk7cqhsZLRqiQjtF/I7G9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xr43KDVn; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755849831; x=1787385831;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PncTHgIjF3nJ8qLaY+C8va7O1RZ8dN4JMH8eZV6EYQk=;
  b=Xr43KDVnxF4ztN6/KUxsD8LQr6F+maFhfQIhoiG7y0TdQNUPNyYqYXO7
   nLEv8JYw3dO3X8KkfUyS7SJGdGuge+PQ/2emAbgf9g9nxlX2V/9DjouQW
   dQgLuoJKiSjKLWxq0/0XWNgpzH/0Lx1ouUaiiDz0F6rrvbWj3sseGRed9
   SeJodb+3nSazorPWZzKKQv9peAM7atNiw1+VTysOlh4JpGVDQ98kPx66G
   Xc//9JPZln5sNu3HDfbAvxh6iTcITIBb0+x5/Jm1sNYmZ+nMB+NK+ek7G
   /8abPF9tqldlXog1kUWRqBuHBtRH97Qw+IqXYN6qWumxaCFqDqpwicIig
   Q==;
X-CSE-ConnectionGUID: QOr3fXixQM+GsGGfmOR3Bg==
X-CSE-MsgGUID: 6eqt+MQ1TJmLIgsqI6T+Lg==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="75610814"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="75610814"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 01:03:50 -0700
X-CSE-ConnectionGUID: oF4KtcS9Rg2bgbcEi4LMBQ==
X-CSE-MsgGUID: J8sXjZpqQlmiblrnSKWjUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="168555292"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 01:03:49 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: peterx@redhat.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 3/3] KVM: selftests: Test resetting dirty ring in gmem slots in protected VMs
Date: Fri, 22 Aug 2025 16:03:04 +0800
Message-ID: <20250822080304.27304-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250822080100.27218-1-yan.y.zhao@intel.com>
References: <20250822080100.27218-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test resetting dirty ring in slots with the KVM_MEM_GUEST_MEMFD flag in
KVM_X86_SW_PROTECTED_VM VMs.

Purposely resetting dirty ring entries incorrectly to point to a gmem slot.

Unlike in TDX VMs, where resetting the dirty ring in a gmem slot could
trigger KVM_BUG_ON(), there are no obvious errors for
KVM_X86_SW_PROTECTED_VM VMs. Therefore, detect SPTE changes by reading
trace messages with the kvm_tdp_mmu_spte_changed event enabled.
Consequently, the test is conducted only when tdp_mmu is enabled and
tracing is available.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../kvm/x86/reset_dirty_ring_on_gmem_test.c   | 392 ++++++++++++++++++
 2 files changed, 393 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/reset_dirty_ring_on_gmem_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index f6fe7a07a0a2..ebd1d829c3f9 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -136,6 +136,7 @@ TEST_GEN_PROGS_x86 += x86/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
 TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
 TEST_GEN_PROGS_x86 += x86/aperfmperf_test
+TEST_GEN_PROGS_x86 += x86/reset_dirty_ring_on_gmem_test
 TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/x86/reset_dirty_ring_on_gmem_test.c b/tools/testing/selftests/kvm/x86/reset_dirty_ring_on_gmem_test.c
new file mode 100644
index 000000000000..cf1746c0149f
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/reset_dirty_ring_on_gmem_test.c
@@ -0,0 +1,392 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test reset dirty ring on gmem slot on x86.
+ * Copyright (C) 2025, Intel, Inc.
+ *
+ * The slot flag KVM_MEM_GUEST_MEMFD is incompatible with the flag
+ * KVM_MEM_LOG_DIRTY_PAGES, which means KVM does not permit dirty page tracking
+ * on gmem slots.
+ *
+ * When dirty ring is enabled, although KVM does not mark GFNs in gmem slots as
+ * dirty, userspace can reset and write arbitrary data into the dirty ring
+ * entries shared between KVM and userspace. This can lead KVM to incorrectly
+ * clear write permission or dirty bits on SPTEs of gmem slots.
+ *
+ * While this might be harmless for non-TDX VMs, it could cause inconsistencies
+ * between the mirror SPTEs and the external SPTEs in hardware, or even trigger
+ * KVM_BUG_ON() for TDX.
+ *
+ * Purposely reset dirty ring incorrectly on gmem slots (gmem slots do not allow
+ * dirty page tracking) to verify malbehaved userspace cannot cause any SPTE
+ * permission reduction change.
+ *
+ * Steps conducted in this test:
+ * 1. echo nop > ${TRACING_ROOT}/current_tracer
+ *    echo 1 > ${TRACING_ROOT}/events/kvmmmu/kvm_tdp_mmu_spte_changed/enable
+ *    echo > ${TRACING_ROOT}/set_event_pid
+ *    echo > ${TRACING_ROOT}/set_event_notrace_pid
+ *
+ * 2. echo "common_pid == $tid && gfn == 0xc0400" > \
+ *    ${TRACING_ROOT}/events/kvmmmu/kvm_tdp_mmu_spte_changed/filter
+ *
+ * 3. echo 0 > ${TRACING_ROOT}/tracing_on
+ *    echo > ${TRACING_ROOT}/trace
+ *    echo 1 > ${TRACING_ROOT}/tracing_on
+ *
+ * 4. purposely reset dirty ring incorrectly
+ *
+ * 5. cat ${TRACING_ROOT}/trace
+ */
+#include <linux/kvm.h>
+#include <asm/barrier.h>
+#include <test_util.h>
+#include <kvm_util.h>
+#include <processor.h>
+
+#define DEBUGFS "/sys/kernel/debug/tracing"
+#define TRACEFS "/sys/kernel/tracing"
+
+#define TEST_DIRTY_RING_GPA (0xc0400000)
+#define TEST_DIRTY_RING_GVA (0x90400000)
+#define TEST_DIRTY_RING_REGION_SLOT 11
+#define TEST_DIRTY_RING_REGION_SIZE 0x200000
+#define TEST_DIRTY_RING_COUNT 4096
+#define TEST_DIRTY_RING_GUEST_WRITE_MAX_CNT 3
+
+static const char *PATTEN = "spte_changed";
+static char *tracing_root;
+
+static int open_path(char *subpath, int flags)
+{
+	static char path[100];
+	int count, fd;
+
+	count = snprintf(path, sizeof(path), "%s/%s", tracing_root, subpath);
+	TEST_ASSERT(count > 0, "Incorrect path\n");
+	fd = open(path, flags);
+	TEST_ASSERT(fd >= 0, "Cannot open %s\n", path);
+
+	return fd;
+}
+
+static void setup_tracing(void)
+{
+	int fd;
+
+	/* set current_tracer to nop */
+	fd = open_path("current_tracer", O_WRONLY);
+	test_write(fd, "nop\n", 4);
+	close(fd);
+
+	/* turn on event kvm_tdp_mmu_spte_changed */
+	fd = open_path("events/kvmmmu/kvm_tdp_mmu_spte_changed/enable", O_WRONLY);
+	test_write(fd, "1\n", 2);
+	close(fd);
+
+	/* clear set_event_pid & set_event_notrace_pid */
+	fd = open_path("set_event_pid", O_WRONLY | O_TRUNC);
+	close(fd);
+
+	fd = open_path("set_event_notrace_pid", O_WRONLY | O_TRUNC);
+	close(fd);
+}
+
+static void filter_event(void)
+{
+	int count, fd;
+	char buf[100];
+
+	fd = open_path("events/kvmmmu/kvm_tdp_mmu_spte_changed/filter",
+		       O_WRONLY | O_TRUNC);
+
+	count = snprintf(buf, sizeof(buf), "common_pid == %d && gfn == 0x%x\n",
+			 gettid(), TEST_DIRTY_RING_GPA >> PAGE_SHIFT);
+	TEST_ASSERT(count > 0, "Incorrect number of data written\n");
+	test_write(fd, buf, count);
+	close(fd);
+}
+
+static void enable_tracing(bool enable)
+{
+	char *val = enable ? "1\n" : "0\n";
+	int fd;
+
+	if (enable) {
+		/* clear trace log before enabling */
+		fd = open_path("trace", O_WRONLY | O_TRUNC);
+		close(fd);
+	}
+
+	fd = open_path("tracing_on", O_WRONLY);
+	test_write(fd, val, 2);
+	close(fd);
+}
+
+static void reset_tracing(void)
+{
+	enable_tracing(false);
+	enable_tracing(true);
+}
+
+static void detect_spte_change(void)
+{
+	static char buf[1024];
+	FILE *file;
+	int count;
+
+	count = snprintf(buf, sizeof(buf), "%s/trace", tracing_root);
+	TEST_ASSERT(count > 0, "Incorrect path\n");
+	file = fopen(buf, "r");
+	TEST_ASSERT(file, "Cannot open %s\n", buf);
+
+	while (fgets(buf, sizeof(buf), file))
+		TEST_ASSERT(!strstr(buf, PATTEN), "Unexpected SPTE change %s\n", buf);
+
+	fclose(file);
+}
+
+/*
+ * Write to a gmem slot and exit to host after each write to allow host to check
+ * dirty ring.
+ */
+void guest_code(void)
+{
+	uint64_t count = 0;
+
+	while (count < TEST_DIRTY_RING_GUEST_WRITE_MAX_CNT) {
+		count++;
+		memset((void *)TEST_DIRTY_RING_GVA, 1, 8);
+		GUEST_SYNC(count);
+	}
+	GUEST_DONE();
+}
+
+/*
+ * Verify that KVM_MEM_LOG_DIRTY_PAGES cannot be set on a memslot with flag
+ * KVM_MEM_GUEST_MEMFD.
+ */
+static void verify_turn_on_log_dirty_pages_flag(struct kvm_vcpu *vcpu)
+{
+	struct userspace_mem_region *region;
+	int ret;
+
+	region = memslot2region(vcpu->vm, TEST_DIRTY_RING_REGION_SLOT);
+	region->region.flags |= KVM_MEM_LOG_DIRTY_PAGES;
+
+	ret = __vm_ioctl(vcpu->vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
+
+	TEST_ASSERT(ret, "KVM_SET_USER_MEMORY_REGION2 incorrectly succeeds\n");
+	region->region.flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
+}
+
+static inline bool dirty_gfn_is_dirtied(struct kvm_dirty_gfn *gfn)
+{
+	return smp_load_acquire(&gfn->flags) == KVM_DIRTY_GFN_F_DIRTY;
+}
+
+static inline void dirty_gfn_set_collected(struct kvm_dirty_gfn *gfn)
+{
+	smp_store_release(&gfn->flags, KVM_DIRTY_GFN_F_RESET);
+}
+
+static bool dirty_ring_empty(struct kvm_vcpu *vcpu)
+{
+	struct kvm_dirty_gfn *dirty_gfns = vcpu_map_dirty_ring(vcpu);
+	struct kvm_dirty_gfn *cur;
+	int i;
+
+	for (i = 0; i < TEST_DIRTY_RING_COUNT; i++) {
+		cur = &dirty_gfns[i];
+
+		if (dirty_gfn_is_dirtied(cur))
+			return false;
+	}
+	return true;
+}
+
+/*
+ * Purposely reset the dirty ring incorrectly by resetting a dirty ring entry
+ * even when KVM does not report the entry as dirty.
+ *
+ * In the kvm_dirty_gfn entry, specify the slot to the gmem slot that does not
+ * allow dirty page tracking and has no flag KVM_MEM_LOG_DIRTY_PAGES.
+ */
+static void reset_dirty_ring(struct kvm_vcpu *vcpu, int *reset_index)
+{
+	struct kvm_dirty_gfn *dirty_gfns = vcpu_map_dirty_ring(vcpu);
+	struct kvm_dirty_gfn *cur = &dirty_gfns[*reset_index];
+	uint32_t cleared;
+
+	reset_tracing();
+
+	cur->slot = TEST_DIRTY_RING_REGION_SLOT;
+	cur->offset = 0;
+	dirty_gfn_set_collected(cur);
+	cleared = kvm_vm_reset_dirty_ring(vcpu->vm);
+	*reset_index += cleared;
+	TEST_ASSERT(cleared == 1, "Unexpected cleared count %d\n", cleared);
+
+	detect_spte_change();
+}
+
+/*
+ * The vCPU worker to loop vcpu_run(). After each vCPU access to a GFN, check if
+ * the dirty ring is empty and reset the dirty ring.
+ */
+static void reset_dirty_ring_worker(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *run = vcpu->run;
+	struct ucall uc;
+	uint64_t cmd;
+	int index = 0;
+
+	filter_event();
+	while (1) {
+		vcpu_run(vcpu);
+
+		if (run->exit_reason == KVM_EXIT_IO) {
+			cmd = get_ucall(vcpu, &uc);
+			if (cmd != UCALL_SYNC)
+				break;
+
+			TEST_ASSERT(dirty_ring_empty(vcpu),
+				    "Guest write should not cause GFN dirty\n");
+
+			reset_dirty_ring(vcpu, &index);
+		}
+	}
+}
+
+static struct kvm_vm *create_vm(unsigned long vm_type, struct kvm_vcpu **vcpu,
+				bool private)
+{
+	unsigned int npages = TEST_DIRTY_RING_REGION_SIZE / getpagesize();
+	const struct vm_shape shape = {
+		.mode = VM_MODE_DEFAULT,
+		.type = vm_type,
+	};
+	struct kvm_vm *vm;
+
+	vm = __vm_create(shape, 1, 0);
+	vm_enable_dirty_ring(vm, TEST_DIRTY_RING_COUNT * sizeof(struct kvm_dirty_gfn));
+	*vcpu = vm_vcpu_add(vm, 0, guest_code);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    TEST_DIRTY_RING_GPA,
+				    TEST_DIRTY_RING_REGION_SLOT,
+				    npages, KVM_MEM_GUEST_MEMFD);
+	vm->memslots[MEM_REGION_TEST_DATA] = TEST_DIRTY_RING_REGION_SLOT;
+	virt_map(vm, TEST_DIRTY_RING_GVA, TEST_DIRTY_RING_GPA, npages);
+	if (private)
+		vm_mem_set_private(vm, TEST_DIRTY_RING_GPA,
+				   TEST_DIRTY_RING_REGION_SIZE);
+	return vm;
+}
+
+struct test_config {
+	unsigned long vm_type;
+	bool manual_protect_and_init_set;
+	bool private_access;
+	char *test_desc;
+};
+
+void test_dirty_ring_on_gmem_slot(struct test_config *config)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	if (config->vm_type &&
+	    !(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(config->vm_type))) {
+		ksft_test_result_skip("\n");
+		return;
+	}
+
+	vm = create_vm(config->vm_type, &vcpu, config->private_access);
+
+	/*
+	 * Let KVM detect that kvm_dirty_log_manual_protect_and_init_set() is
+	 * true in kvm_arch_mmu_enable_log_dirty_pt_masked() to check if
+	 * kvm_mmu_slot_gfn_write_protect() will be called on a gmem memslot.
+	 */
+	if (config->manual_protect_and_init_set) {
+		u64 manual_caps;
+
+		manual_caps = kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
+
+		manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
+				KVM_DIRTY_LOG_INITIALLY_SET);
+
+		if (!manual_caps)
+			return;
+
+		vm_enable_cap(vm, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, manual_caps);
+	}
+
+	verify_turn_on_log_dirty_pages_flag(vcpu);
+
+	reset_dirty_ring_worker(vcpu);
+
+	kvm_vm_free(vm);
+	ksft_test_result_pass("\n");
+}
+
+static bool dirty_ring_supported(void)
+{
+	return (kvm_has_cap(KVM_CAP_DIRTY_LOG_RING) ||
+		kvm_has_cap(KVM_CAP_DIRTY_LOG_RING_ACQ_REL));
+}
+
+static bool has_tracing(void)
+{
+	if (faccessat(AT_FDCWD, DEBUGFS, F_OK, AT_EACCESS) == 0) {
+		tracing_root = DEBUGFS;
+		return true;
+	}
+
+	if (faccessat(AT_FDCWD, TRACEFS, F_OK, AT_EACCESS) == 0) {
+		tracing_root = TRACEFS;
+		return true;
+	}
+
+	return false;
+}
+
+static struct test_config tests[] = {
+	{
+		.vm_type = KVM_X86_SW_PROTECTED_VM,
+		.manual_protect_and_init_set = false,
+		.private_access = true,
+		.test_desc = "SW_PROTECTED_VM, manual_protect_and_init_set=false, private access",
+	},
+	{
+		.vm_type = KVM_X86_SW_PROTECTED_VM,
+		.manual_protect_and_init_set = true,
+		.private_access = true,
+		.test_desc = "SW_PROTECTED_VM, manual_protect_and_init_set=true, private access",
+	},
+};
+
+int main(int argc, char **argv)
+{
+	int test_cnt = ARRAY_SIZE(tests);
+
+	ksft_print_header();
+	ksft_set_plan(test_cnt);
+
+	TEST_REQUIRE(get_kvm_param_bool("tdp_mmu"));
+	TEST_REQUIRE(has_tracing());
+	TEST_REQUIRE(dirty_ring_supported());
+
+	setup_tracing();
+
+	for (int i = 0; i < test_cnt; i++) {
+		pthread_t vm_thread;
+
+		pthread_create(&vm_thread, NULL,
+			       (void *(*)(void *))test_dirty_ring_on_gmem_slot,
+			       &tests[i]);
+		pthread_join(vm_thread, NULL);
+	}
+
+	ksft_finished();
+	return 0;
+}
-- 
2.43.2


