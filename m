Return-Path: <kvm+bounces-72919-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kK1BCGjEqWm2EQEAu9opvQ
	(envelope-from <kvm+bounces-72919-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:59:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 09422216AD8
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C33B2304F00B
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D761047B425;
	Thu,  5 Mar 2026 17:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QDEWJw4t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDA34301CC;
	Thu,  5 Mar 2026 17:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732700; cv=none; b=LlXK/O9hNdFrlfeQ9l7+qFQ/3TXJJL4uKhtAkv/NwXnkf+WzvSBpuA8+CSi9mGQaxL0T68Pcun5LmkHep9RVZR+dUnUX251xY4drkEJkNJmpWx6FXimQTqa+nCZVqZCW86mn+0OiD6mawhBQuagU1rjvhIn7VKXB6ad3jSx79/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732700; c=relaxed/simple;
	bh=dWLBpucUmsronW0lUyENxbo4bN8m5VbkFlRPqfDok1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kj3/sH1aFKECTe6bn9K6NuutvbYceq420For0SbUZrE59yyo8pUvXK3Fs7NTt05g8dqWGY/1I7P7tVtcY01Uk4NANX2zp1+qqwGPQVpPxe6nB+zUBefU622V6jgMQ1E5KxTNyAdfbzKTG+KYo1s0qOWNzS7ZAMnG0pN3bQUkVqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QDEWJw4t; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732694; x=1804268694;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dWLBpucUmsronW0lUyENxbo4bN8m5VbkFlRPqfDok1Q=;
  b=QDEWJw4tJYz16SsqmoPgeO4XyjJfp5KS0nwiDJgkZT9Ex2fIv3acnofq
   c76HOORBZtuViKsGfAe2pKdUfZDWnhbVP3I7EeAUPZ/VzITbiUew/a70R
   jSwdstJrCStFMyOWcVzV+oIUtQ55HGn2cacsyLYLfMD1zlBIA1/DCSS8D
   SlKDO6nGURTaVBg8JZULQeVnl8PXN78cn991c3wXhcQtZheO5gC+L77F+
   8r8S92S60rnO0c2ProdOXeyrB1go6Ny/lvMDyUZyI9bERNB5U8DsSj6jT
   Z8hpDQiXbL59AObFlqEt6Z843vpufQscuRVUDyP0H2F/KgijowLikOTWu
   A==;
X-CSE-ConnectionGUID: Jl0zst6JRM+usUGRuETk3Q==
X-CSE-MsgGUID: XFtMCUfVQ/2dVoK1i31dQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77701145"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77701145"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:53 -0800
X-CSE-ConnectionGUID: Vo2oajuFQC2bQ7gvV8OQow==
X-CSE-MsgGUID: hBXIS251RdKoGzCdim8g/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="256647686"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:53 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 32/36] KVM: selftests: Test cases for L1 APIC timer virtualization
Date: Thu,  5 Mar 2026 09:44:12 -0800
Message-ID: <e8c9ecbab9787c6ae8f6f97debfbcdaae1f387dd.1772732517.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1772732517.git.isaku.yamahata@intel.com>
References: <cover.1772732517.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 09422216AD8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72919-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Test nVMX APIC timer virtualization for L1 to see how KVM in L0 works.
It exercises KVM TSC deadline conversion between L0 and L1.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes:
v1 -> v2:
- Add check serialize instruction support.
- Eliminate unused variable warnings.
- Add serialize() after disabling deadline timer.
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../kvm/x86/vmx_apic_timer_virt_test.c        | 317 ++++++++++++++++++
 2 files changed, 318 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index f0023bab1cd7..424ae9a56481 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -146,6 +146,7 @@ TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
 TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
 TEST_GEN_PROGS_x86 += x86/aperfmperf_test
 TEST_GEN_PROGS_x86 += x86/timer_latency
+TEST_GEN_PROGS_x86 += x86/vmx_apic_timer_virt_test
 TEST_GEN_PROGS_x86 += x86/vmx_apic_timer_virt_vmcs_test
 TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
diff --git a/tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_test.c b/tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_test.c
new file mode 100644
index 000000000000..3eb544363570
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_test.c
@@ -0,0 +1,317 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Intel Corporation
+ *
+ * Test timer expiration conversion and exercise various LVTT mode.
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "vmx.h"
+
+#include <string.h>
+#include <sys/ioctl.h>
+#include <stdatomic.h>
+
+#include <linux/math64.h>
+
+static uint64_t host_tsc_khz;
+static uint64_t max_guest_tsc_khz;
+
+/* Any value [32, 255] for timer vector is okay. */
+#define TIMER_VECTOR   0xec
+
+static atomic_int timer_interrupted;
+
+static void guest_timer_interrupt_handler(struct ex_regs *regs)
+{
+	atomic_fetch_add(&timer_interrupted, 1);
+	x2apic_write_reg(APIC_EOI, 0);
+}
+
+static void reap_interrupt(void)
+{
+	GUEST_ASSERT(!wrmsr_safe(MSR_IA32_TSC_DEADLINE, 0));
+	serialize();
+	sti_nop_cli();
+}
+
+static void deadline_write_test(bool do_interrupt, bool mask,
+				uint64_t deadlines[], size_t nr_deadlines)
+{
+	int i;
+
+	for (i = 0; i < nr_deadlines; i++) {
+		uint64_t deadline = deadlines[i];
+		uint64_t val;
+
+		reap_interrupt();
+
+		atomic_store(&timer_interrupted, 0);
+		sti();
+		GUEST_ASSERT(!wrmsr_safe(MSR_IA32_TSC_DEADLINE, deadline));
+		/* serialize to wait for timer interrupt to fire. */
+		serialize();
+		cli();
+
+		GUEST_ASSERT(!rdmsr_safe(MSR_IA32_TSC_DEADLINE, &val));
+
+		if (do_interrupt) {
+			GUEST_ASSERT(val == 0);
+			if (mask || deadline == 0)
+				GUEST_ASSERT_EQ(atomic_load(&timer_interrupted), 0);
+			else
+				GUEST_ASSERT_EQ(atomic_load(&timer_interrupted), 1);
+		} else {
+			GUEST_ASSERT_EQ(val, deadline);
+			GUEST_ASSERT_EQ(atomic_load(&timer_interrupted), 0);
+		}
+	}
+}
+
+static void deadline_write_hlt_test(uint64_t deadlines[], size_t nr_deadlines)
+{
+	int i;
+
+	for (i = 0; i < nr_deadlines; i++) {
+		uint64_t deadline = deadlines[i];
+		uint64_t val;
+
+		reap_interrupt();
+
+		GUEST_ASSERT(deadline);
+
+		atomic_store(&timer_interrupted, 0);
+		GUEST_ASSERT(!wrmsr_safe(MSR_IA32_TSC_DEADLINE, deadline));
+
+		GUEST_ASSERT(!rdmsr_safe(MSR_IA32_TSC_DEADLINE, &val));
+		GUEST_ASSERT(val == deadline || val == 0);
+		GUEST_ASSERT_EQ(atomic_load(&timer_interrupted), 0);
+
+		asm volatile ("sti; hlt; nop; cli"
+			      /* L1 exit handler doesn't preserve GP registers. */
+			      : : : "cc", "memory",
+				"rax", "rbx", "rcx", "rdx", "rsi", "rdi", "rbp",
+				"r8", "r9", "r10", "r11", "r12", "r13", "r14",
+				"r15");
+
+		GUEST_ASSERT(!rdmsr_safe(MSR_IA32_TSC_DEADLINE, &val));
+		GUEST_ASSERT_EQ(val, 0);
+		GUEST_ASSERT_EQ(atomic_load(&timer_interrupted), 1);
+	}
+}
+
+static void deadline_no_int_test(void)
+{
+	uint64_t tsc = rdtsc();
+	uint64_t deadlines[] = {
+		0ull,
+		/* big values > tsc. */
+		max(~0ull - tsc, ~0ull / 2 + tsc / 2),
+		~0ull - 1,
+		~0ull - 2,
+		~0ull,
+	};
+
+	deadline_write_test(false, false, deadlines, ARRAY_SIZE(deadlines));
+}
+
+static void __deadline_int_test(bool do_interrupt, bool mask)
+{
+	uint64_t tsc = rdtsc();
+	uint64_t deadlines[] = {
+		0ull,
+		1ull,
+		2ull,
+		/* 1 msec past. tsc /2 is to avoid underflow. */
+		min(tsc - guest_tsc_khz, tsc / 2 + 1),
+		tsc,
+	};
+
+	deadline_write_test(do_interrupt, mask, deadlines, ARRAY_SIZE(deadlines));
+}
+
+static void deadline_int_test(void)
+{
+	__deadline_int_test(true, false);
+}
+
+static void deadline_int_mask_test(void)
+{
+	__deadline_int_test(true, true);
+}
+
+static void deadline_hlt_test(void)
+{
+	uint64_t tsc = rdtsc();
+	/* 1 msec future. */
+	uint64_t future = tsc + guest_tsc_khz;
+	uint64_t deadlines[] = {
+		1ull,
+		2ull,
+		/* pick a positive value between [0, tsc]. */
+		tsc > guest_tsc_khz ? tsc - guest_tsc_khz : tsc / 2 + 1,
+		tsc,
+		/* If overflow, pick near future value > tsc. */
+		future > tsc ? future : ~0ull / 2 + tsc / 2,
+	};
+
+	deadline_write_hlt_test(deadlines, ARRAY_SIZE(deadlines));
+}
+
+static void guest_code(void)
+{
+	x2apic_enable();
+
+	x2apic_write_reg(APIC_LVTT, APIC_LVT_TIMER_TSCDEADLINE | TIMER_VECTOR);
+	deadline_no_int_test();
+	deadline_int_test();
+	deadline_hlt_test();
+
+	x2apic_write_reg(APIC_LVTT, APIC_LVT_TIMER_TSCDEADLINE |
+			 APIC_LVT_MASKED | TIMER_VECTOR);
+	deadline_no_int_test();
+	deadline_int_mask_test();
+
+	GUEST_DONE();
+}
+
+static void run_vcpu(struct kvm_vcpu *vcpu)
+{
+	bool done = false;
+
+	while (!done) {
+		struct ucall uc;
+
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			/* NOT REACHED */
+		case UCALL_SYNC:
+			break;
+		case UCALL_PRINTF:
+			pr_info("%s", uc.buffer);
+			break;
+		case UCALL_DONE:
+			done = true;
+			break;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+}
+
+static int test_tsc_deadline(bool tsc_offset, uint64_t guest_tsc_khz__)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	if (guest_tsc_khz__) {
+		int ret;
+
+		ret = __vcpu_ioctl(vcpu, KVM_SET_TSC_KHZ, (void *)guest_tsc_khz__);
+		if (ret) {
+			kvm_vm_free(vm);
+			return ret;
+		}
+
+		guest_tsc_khz = guest_tsc_khz__;
+	}
+
+	if (tsc_offset) {
+		uint64_t offset;
+
+		__TEST_REQUIRE(!__vcpu_has_device_attr(vcpu, KVM_VCPU_TSC_CTRL,
+						       KVM_VCPU_TSC_OFFSET),
+			       "KVM_VCPU_TSC_OFFSET not supported; skipping test");
+
+		/*
+		 * Make the conversion guest deadline virt(L1) => phy (l0)
+		 * can overflow/underflow.
+		 */
+		offset = -rdtsc();
+		vcpu_device_attr_set(vcpu, KVM_VCPU_TSC_CTRL,
+				     KVM_VCPU_TSC_OFFSET, &offset);
+	}
+
+	vcpu_set_cpuid_feature(vcpu, X86_FEATURE_TSC_DEADLINE_TIMER);
+	vm_install_exception_handler(vm, TIMER_VECTOR,
+				     guest_timer_interrupt_handler);
+
+	sync_global_to_guest(vm, host_tsc_khz);
+	sync_global_to_guest(vm, guest_tsc_khz);
+	run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
+
+static void test(void)
+{
+	uint64_t guest_tsc_khz__;
+	int r;
+
+	test_tsc_deadline(false, 0);
+	test_tsc_deadline(true, 0);
+
+	for (guest_tsc_khz__ = host_tsc_khz; guest_tsc_khz__ > 0;
+	     guest_tsc_khz__ >>= 1) {
+		r = test_tsc_deadline(false, guest_tsc_khz__);
+		if (r)
+			break;
+
+		test_tsc_deadline(true, guest_tsc_khz__);
+	}
+
+	for (guest_tsc_khz__ = host_tsc_khz; guest_tsc_khz__ < max_guest_tsc_khz;
+	     guest_tsc_khz__ <<= 1) {
+		r = test_tsc_deadline(false, guest_tsc_khz__);
+		if (r)
+			break;
+
+		test_tsc_deadline(true, guest_tsc_khz__);
+	}
+
+	test_tsc_deadline(false, max_guest_tsc_khz);
+	test_tsc_deadline(true, max_guest_tsc_khz);
+}
+
+int main(int argc, char *argv[])
+{
+	uint32_t eax_denominator, ebx_numerator, ecx_hz, edx;
+
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_X2APIC));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SERIALIZE));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_TSC_CONTROL));
+
+	cpuid(0x15, &eax_denominator, &ebx_numerator, &ecx_hz, &edx);
+	TEST_REQUIRE(ebx_numerator > 0);
+	TEST_REQUIRE(eax_denominator > 0);
+
+	if (ecx_hz > 0)
+		host_tsc_khz = ecx_hz * ebx_numerator / eax_denominator / 1000;
+	else {
+		uint32_t eax_base_mhz, ebx, ecx;
+
+		cpuid(0x16, &eax_base_mhz, &ebx, &ecx, &edx);
+		host_tsc_khz = eax_base_mhz * 1000 * ebx_numerator /
+			eax_denominator;
+	}
+	TEST_REQUIRE(host_tsc_khz > 0);
+
+	/* See arch/x86/kvm/{x86.c, vmx/vmx.c}. There is no way for userspace to retrieve it. */
+#define KVM_VMX_TSC_MULTIPLIER_MAX	0xffffffffffffffffULL
+	max_guest_tsc_khz = min((uint64_t)0x7fffffffULL,
+				mul_u64_u32_shr(KVM_VMX_TSC_MULTIPLIER_MAX, host_tsc_khz, 48));
+
+	test();
+
+	return 0;
+}
-- 
2.45.2


