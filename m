Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EE16647BB
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 18:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbjAJRv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 12:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbjAJRvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 12:51:18 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19DF5F912
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:51:17 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id bx21-20020a056a00429500b00582d85bb03bso5546170pfb.16
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kovpab8ufZORC8OQwD/Ffe4tjc6Lhn/m/+zBtc75xtg=;
        b=jMZkxMMsqWv4TR7GzZ0A7yhf0SNqy4OOCj6DEGOQl/IHadL2JpeOyeLieFcExLaRH+
         nC7f/8hRRK2ZDY8aJJS7Isg8WIjwIqAAP3IDu3db0HKTcWPRoWdVX1XSuF+7WySHus97
         UC5xJljIGHCht8YAYZgSXXAMH42IdS9I42o0QHTMnN1Of3nWaBtQixI6ZDup12CBJQnL
         02FdR3pDScSNA4le2Wc+FdRUb3KHDY3NQb7agC5kIDo40Jh7nROKzfi/rV4ABfS00M8n
         2bz7L5pb9uXenODU9xH+unSgUVvxe3BdcNIMWg3FcoFhvIWRhR4p+mAgEL7y8SdmAj5+
         9P7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kovpab8ufZORC8OQwD/Ffe4tjc6Lhn/m/+zBtc75xtg=;
        b=2cFnjrYlNeliGcgCVpC8RXhf6FvFy5Aam5BCI7e7DjiCIYpYLL7zwy2p7pa19gdGSP
         xiCQvYmsm8YmHS2kKrvlU0Ev5lT27BEyYDaACNLUokloXwDxKqu9/nqBTEsivFUOH/Ma
         4P+gDzEP40AOMpcPdNoNJY/14DS3++x0LpaIoSfn1FVjRHzQWMwDO748ITZHRKKcYQpK
         8hNB/I1jbRgx2+zTsB1XrAugxY5TEPFZTZlM3JAFBFFfmtqtMGwZZMPwtv1zTz4Iumtl
         PqGMQgm7XihI4hZlIDXEvVAmiJaWDrXU2roITZcYOm0NdNXNB1Z9QJ6rIKUC/xWwDnfr
         pvkg==
X-Gm-Message-State: AFqh2kpnQCn2UZb1VoCSvqVnX+m1BTf/MiVUsynqd1K0/6jqbsQY97Rr
        OYRjFAFbit+EYm6cTE23RACacCMz0Nr96UXwbdcl4JAYZRtqUzUbdjyjJIWw5swrwjr/jKHgRDa
        fCUc++hxFS1wKCC4Rn+7vZIhMwusBxAks8+Ve+Rm/2UaVfLYpdgB+94M0JQ==
X-Google-Smtp-Source: AMrXdXtROTaAuScbQiP5lFAmT1xtN9L9Dqm038NELJz/DOHnZMYDutBsJxvjLk/8D/IZFYJyMBlpKlEadsk=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:8358:4c2a:eae1:4752])
 (user=pgonda job=sendgmr) by 2002:a17:90a:206:b0:226:9980:67f3 with SMTP id
 c6-20020a17090a020600b00226998067f3mr280pjc.1.1673373076771; Tue, 10 Jan 2023
 09:51:16 -0800 (PST)
Date:   Tue, 10 Jan 2023 09:50:57 -0800
In-Reply-To: <20230110175057.715453-1-pgonda@google.com>
Message-Id: <20230110175057.715453-8-pgonda@google.com>
Mime-Version: 1.0
References: <20230110175057.715453-1-pgonda@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Subject: [PATCH V6 7/7] KVM: selftests: Add simple sev vm testing
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A very simple of booting SEV guests that checks related CPUID bits. This
is a stripped down version of "[PATCH v2 08/13] KVM: selftests: add SEV
boot tests" from Michael but much simpler.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Suggested-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 tools/testing/selftests/kvm/.gitignore        | 84 +++++++++++++++++++
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/x86_64/sev_all_boot_test.c  | 84 +++++++++++++++++++
 3 files changed, 169 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 6d9381d60172..6d826957c6ae 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,7 +1,91 @@
 # SPDX-License-Identifier: GPL-2.0-only
+<<<<<<< HEAD
 *
 !/**/
 !*.c
 !*.h
 !*.S
 !*.sh
+=======
+/aarch64/aarch32_id_regs
+/aarch64/arch_timer
+/aarch64/debug-exceptions
+/aarch64/get-reg-list
+/aarch64/hypercalls
+/aarch64/psci_test
+/aarch64/vcpu_width_config
+/aarch64/vgic_init
+/aarch64/vgic_irq
+/s390x/memop
+/s390x/resets
+/s390x/sync_regs_test
+/s390x/tprot
+/x86_64/amx_test
+/x86_64/cpuid_test
+/x86_64/cr4_cpuid_sync_test
+/x86_64/debug_regs
+/x86_64/evmcs_test
+/x86_64/emulator_error_test
+/x86_64/fix_hypercall_test
+/x86_64/get_msr_index_features
+/x86_64/kvm_clock_test
+/x86_64/kvm_pv_test
+/x86_64/hyperv_clock
+/x86_64/hyperv_cpuid
+/x86_64/hyperv_features
+/x86_64/hyperv_svm_test
+/x86_64/max_vcpuid_cap_test
+/x86_64/mmio_warning_test
+/x86_64/monitor_mwait_test
+/x86_64/nested_exceptions_test
+/x86_64/nx_huge_pages_test
+/x86_64/platform_info_test
+/x86_64/pmu_event_filter_test
+/x86_64/set_boot_cpu_id
+/x86_64/set_sregs_test
+/x86_64/sev_all_boot_test
+/x86_64/sev_migrate_tests
+/x86_64/smm_test
+/x86_64/state_test
+/x86_64/svm_vmcall_test
+/x86_64/svm_int_ctl_test
+/x86_64/svm_nested_soft_inject_test
+/x86_64/sync_regs_test
+/x86_64/tsc_msrs_test
+/x86_64/tsc_scaling_sync
+/x86_64/ucna_injection_test
+/x86_64/userspace_io_test
+/x86_64/userspace_msr_exit_test
+/x86_64/vmx_apic_access_test
+/x86_64/vmx_close_while_nested_test
+/x86_64/vmx_dirty_log_test
+/x86_64/vmx_exception_with_invalid_guest_state
+/x86_64/vmx_invalid_nested_guest_state
+/x86_64/vmx_msrs_test
+/x86_64/vmx_preemption_timer_test
+/x86_64/vmx_set_nested_state_test
+/x86_64/vmx_tsc_adjust_test
+/x86_64/vmx_nested_tsc_scaling_test
+/x86_64/xapic_ipi_test
+/x86_64/xapic_state_test
+/x86_64/xen_shinfo_test
+/x86_64/xen_vmcall_test
+/x86_64/xss_msr_test
+/x86_64/vmx_pmu_caps_test
+/x86_64/triple_fault_event_test
+/access_tracking_perf_test
+/demand_paging_test
+/dirty_log_test
+/dirty_log_perf_test
+/hardware_disable_test
+/kvm_create_max_vcpus
+/kvm_page_table_test
+/max_guest_memory_test
+/memslot_modification_stress_test
+/memslot_perf_test
+/rseq_test
+/set_memory_region_test
+/steal_time
+/kvm_binary_stats_test
+/system_counter_offset_test
+>>>>>>> KVM: selftests: Add simple sev vm testing
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index b7cfb15712d1..66d7ab3da990 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -111,6 +111,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_caps_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
+TEST_GEN_PROGS_x86_64 += x86_64/sev_all_boot_test
 TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
diff --git a/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c b/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c
new file mode 100644
index 000000000000..e9e4d7305bc1
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Basic SEV boot tests.
+ *
+ */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+#include "linux/psp-sev.h"
+#include "sev.h"
+
+#define NR_SYNCS 1
+
+#define MSR_AMD64_SEV_BIT  1
+
+static void guest_run_loop(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+	int i;
+
+	for (i = 0; i <= NR_SYNCS; ++i) {
+		vcpu_run(vcpu);
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			continue;
+		case UCALL_DONE:
+			return;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+		default:
+			TEST_FAIL("Unexpected exit: %s",
+				  exit_reason_str(vcpu->run->exit_reason));
+		}
+	}
+}
+
+static void is_sev_enabled(void)
+{
+	uint64_t sev_status;
+
+	GUEST_ASSERT(this_cpu_has(X86_FEATURE_SEV));
+
+	sev_status = rdmsr(MSR_AMD64_SEV);
+	GUEST_ASSERT(sev_status & 0x1);
+}
+
+static void guest_sev_code(void)
+{
+	GUEST_SYNC(1);
+
+	is_sev_enabled();
+
+	GUEST_DONE();
+}
+
+static void test_sev(void *guest_code, uint64_t policy)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+
+	vm = vm_sev_create_with_one_vcpu(policy, guest_code, &vcpu);
+	TEST_ASSERT(vm, "vm_sev_create_with_one_vcpu() failed to create VM\n");
+
+	guest_run_loop(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(is_kvm_sev_supported());
+
+	test_sev(guest_sev_code, SEV_POLICY_NO_DBG);
+	test_sev(guest_sev_code, 0);
+
+	return 0;
+}
-- 
2.39.0.314.g84b9a713c41-goog

